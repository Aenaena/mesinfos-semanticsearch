americano = require 'americano-cozy'

module.exports = ProgressStore = americano.getModel 'semsearchprogressstore',
    'refdoctype': String
    'progresses': (x) -> x

ProgressStore.byDoctype = (doctype, callback) ->
    ProgressStore.request 'byDoctype', key: doctype, (err, docs) ->
        callback err, docs?[0]?.progresses or {}

ProgressStore.store = (doctype, data, callback) ->
    ProgressStore.request 'byDoctype', key: doctype, (err, docs) ->
        return callback err if err
        exist = docs?[0]
        if exist then exist.updateAttributes progresses: data, callback
        else
            store = refdoctype: doctype, progresses: data
            ProgressStore.create store, (err, doc) ->
                callback err, doc
