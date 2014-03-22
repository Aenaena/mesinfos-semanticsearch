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
            return callback err if err
            RDFStorage.saveChanges done


handleDoctype = (store, doctype, progresses, callback) ->
    Model = require "./models/#{doctype}"

    onCreated = (model, callback) ->
        console.log "ONCREATED, id = ", id
        async.parallel [
            (cb) ->
                return cb null if Model.indexFields.length is 0
                indexer.index model, Model.indexFields, cb
            (cb) ->
                graph = model.toRDFGraph?()
                return cb null unless model.toRDFGraph
                store.insert graph, cb
        ], callback

    onDeleted = (id, callback) ->
        console.log "ONDELETED, id = ", id
        async.parallel [
            (cb) -> indexer.clean id, cb
            (cb) ->
                store.node "my:#{id}", (success, graph) ->
                    return cb new Error("cant get node my:#{id}") unless success
                    store.delete graph, (success, graph) ->
                        err = new Error("cant delete node my:#{id}") unless success
                        cb err
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
        deleted = (id for id, model of progresses)
        async.each deleted, onDeleted, (err) ->
            callback null, next

