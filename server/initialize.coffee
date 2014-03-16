progressHandler = require './lib/progresshandler'
processes = require './processes/index'
iterator = require './lib/iterator'
store = require './store'
async = require 'async'

module.exports = (done) ->

    store.init (err) ->
        return done err if err
        # foreach doctype we handle
        doctypes = ['contact', 'phonecommunicationlog']
        async.eachSeries doctypes, (doctype, cb) ->

            # retrieve current progress
            progressHandler.retrieve doctype, (err, store) ->
                return cb err if err

                # handle current status
                handleDoctype doctype, store, (err, result) ->
                    return cb err if err

                    # store handled _revs
                    progressHandler.store doctype, result, cb

        , done


handleDoctype = (doctype, store, callback) ->
    Model = require "./models/#{doctype}"
    {onCreated, onUpdated, onDeleted} = processes.makeHandlers doctype

    next = {}
    # do not load all models in memory at once
    iterator.batch Model.batchSize, Model, (models, cbBatch) ->
        created = []
        updated = []

        for model in models
            lastRev = store[model._id]
            delete store[model._id]
            if lastRev is null
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
        deleted = (id for id, model of store)
        async.each deleted, onDeleted, (err) ->
            callback null, next

