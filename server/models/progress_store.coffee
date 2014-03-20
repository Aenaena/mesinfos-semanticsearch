americano = require 'americano-cozy'

module.exports = ProgressStore = americano.getModel 'progressStore',
    'refdoctype': String
    'progresses': (x) -> x

ProgressStore.byDoctype = (doctype, callback) ->
    ProgressStore.request 'byDoctype', key: doctype, (err, docs) ->
        callback err, docs?[0] or {}

ProgressStore.store = (doctype, data, callback) ->
    ProgressStore.byDoctype doctype, (err, exist) ->
        return callback err if err
        if exist.updateAttributes then exist.updateAttributes progresses: data, callback
        else ProgressStore.create refdoctype: doctype, progresses: data, callback