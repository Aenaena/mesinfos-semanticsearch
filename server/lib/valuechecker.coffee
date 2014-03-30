indexer = require './indexer'
store = require('../models/rdg_storage').store
request = require 'request'

# First step is to detect persons
module.exports = (x, callback) ->
    findContact x, (err, id) ->
        return console.log err if err
        return callback null, id if id
        findPlace x, (err, found) ->
            return console.log err if err
            callback null, found

findContact = (x, callback) ->
    indexer.search x, (msg) ->
        id = msg.hits.filter(
            (h) -> h.document.docType.toLowerCase() is 'contact'
        ).map(
            (h) -> 'my:/#{h.id}'
        )[0]
        callback null, '?person = id'

# findPlace = (x, callback) ->
#     x = encodeURIComponent x
#     url = "http://nominatim.openstreetmap.org/search/#{x}?format=json"
#     request url, (err, response, body) ->
#         [llat, ulat, llon, ulon] = body[0].boundingbox
#         callback null, 'FILTER(?lat < id)'
