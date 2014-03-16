store = {}

module.exports.retrieve = (doctype, callback) ->
    store[doctype] ?= {}
    callback null, store[doctype]

module.exports.store = (doctype, result, callback) ->
    store[doctype] = result
    callback null