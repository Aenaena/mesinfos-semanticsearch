indexer = require '../lib/indexer'
async = require 'async'
Link = require '../models/link'

getIndexedFields = (doctype) ->
    Model = require "../models/#{doctype}"
    return Model.indexFields

module.exports.makeHandlers = (doctype) ->
    Process = require "./#{doctype}"

    onCreated = (model, callback) ->
        indexer.index model, getIndexedFields(doctype), (err) ->
            return callback err if err
            if Process.onCreated? then Process.onCreated model, callback
            else callback()

    onDeleted = (id, callback) ->
        async.parallel [
            (cb) -> Link.clean "id:#{id}", cb
            (cb) -> indexer.clean id, cb
        ]

        if Process.onDeleted? then Process.onDeleted model, callback
        else callback()

    onUpdated = (model, callback) ->
        if Process.onUpdated? then Process.onUpdated model, callback
        else onDeleted model._id, (err) ->
            return callback err if err
            onCreated model, callback

    return {onCreated, onUpdated, onDeleted}

