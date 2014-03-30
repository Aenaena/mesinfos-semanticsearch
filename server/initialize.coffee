RDFStorage = require './models/rdf_storage'
ProgressStore = require './models/progress_store'
async = require 'async'
iterator = require './lib/iterator'
indexer = require './lib/indexer'

module.exports = (done) ->

    RDFStorage.init (err, store) ->
        return done err if err
        # foreach doctype we handle
        doctypes = ['contact', 'phonecommunicationlog']
        async.eachSeries doctypes, (doctype, cb) ->
            console.log "BEGIN DOCTYPE", doctype

            # retrieve current progress
            ProgressStore.byDoctype doctype, (err, progresses) ->
                return cb err if err
                console.log "    PROGRESS = ", Object.keys(progresses).length

                # handle current status
                handleDoctype store, doctype, progresses, (err, result) ->
                    return cb err if err

                    console.log "    RESULT = ", Object.keys(result).length

                    # store handled _revs
                    ProgressStore.store doctype, result, cb

        , (err) ->
            return done err if err
            RDFStorage.saveChanges done


handleDoctype = (store, doctype, progresses, callback) ->
    Model = require "./models/#{doctype}"

    onCreated = (model, callback) ->
        # console.log "ONCREATED, id = ", model._id
        async.parallel [
            (cb) ->
                toIndex = ['docType'].concat Model.indexFields
                return cb null if toIndex.length is 1
                indexer.index model, toIndex, cb
            (cb) ->
                graph = (new Model(model)).toRDFGraph RDFStorage.tools
                return cb null unless graph
                store.insert graph, (success) ->
                    return cb new Error('failed to insert') unless success
                    cb null
        ], callback

    onDeleted = (id, callback) ->
        # console.log "ONDELETED, id = ", id

        async.parallel [
            (cb) -> indexer.clean id, cb
            (cb) ->
                n = store.rdf.resolve("my:#{id}")
                store.node n, (success, graph) ->
                    unless success
                        return cb new Error("cant get node #{JSON.stringify(n)}")

                    return cb null unless graph.triples.length

                    store.delete graph, (success) ->
                        unless success
                            return cb new Error("cant delete node my:#{id}")
                        cb null
        ], callback

    onUpdated = (model, callback) ->
        onDeleted model._id, (err) ->
            return callback err if err
            onCreated model, callback

    next = {}
    # do not load all models in memory at once
    iterator.batch Model.batchSize, Model, (models, cbBatch) ->
        created = []
        updated = []

        for model in models
            lastRev = progresses[model._id]
            delete progresses[model._id]
            unless lastRev?
                created.push model
            else if lastRev isnt model._rev
                updated.push model
            # else model unchanged, do nothing

        async.parallel [
            (cb) -> async.each created, onCreated, cb
            (cb) -> async.each updated, onUpdated, cb
        ], (err) ->
            return cbBatch err if err
            next[model._id] = model._rev for model in models
            cbBatch null

    , (err) ->
        # what's left in the store are models that were here and are gone
        return callback err if err
        deleted = (id for id, model of progresses)
        async.each deleted, onDeleted, (err) ->
            callback null, next

