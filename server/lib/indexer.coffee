si = require 'search-index'
i = 0

exports.index = (doc, fields, cb) ->
    return cb null
    batch = {}
    toIndex = batch[doc._id] = {}
    toIndex[field] = doc[field] for field in fields when doc[field]
    console.log toIndex, fields
    si.index JSON.stringify(batch), "file#{i++}", fields, (msg) ->
        err = new Error(msg) unless msg.substr(7) is 'indexed'
        cb(err)

exports.clean = (id, cb) ->
    return cb null
    si.deleteDoc id, (msg) ->
        err = new Error(msg) unless msg.substr(7) is 'deleted'
        cb(err)

exports.search = (query, cb) ->
    return cb null
    q =
        query: [query]
        offset: 0
        pageSize: 10
    si.indexData (msg) -> console.log msg
    si.search q, (msg) ->
        console.log msg
        cb null