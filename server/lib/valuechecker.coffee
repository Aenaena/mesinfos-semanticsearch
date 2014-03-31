indexer = require './indexer'
store = require('../models/rdf_storage').store
request = require 'request'

module.exports = (x, results, callback) ->
    findInDB x, results, (err, result) ->
        return callback err if err or result

        findPlace x, results, (err, result) ->

            callback err

findInDB = (x, results, next) ->
    indexer.search x, (err, msg) ->
        console.log "SEARCH RESULT", x, msg

        return next null, false if msg.hits.length is 0

        # consider more than first results ?
        hit = msg.hits[0]
        if hit.document.docType.toLowerCase() is 'contact'
            results.subjects.unshift '?person'
            results.filters.push "?person = my:#{hit.id}"
        #else other doctype ?

        next null, true

findPlace = (x, results, next) ->
    x = encodeURIComponent x
    url = "http://nominatim.openstreetmap.org/search/#{x}?format=json"
    request url: url, json: true, (err, response, body) ->

        console.log url, err, body
        return next null, false if body.length is 0

        [llat, ulat, llon, ulon] = body[0].boundingbox
        results.subjects.push '?point'
        results.concrete.push s: '?point', p: 'geo:lat', o: '?lat'
        results.concrete.push s: '?point', p: 'geo:long', o: '?long'
        results.filters.push [
            '?lat < "' + ulat + '"^^xsd:float',
            '?lat > "' + llat + '"^^xsd:float',
            '?long < "' + ulon + '"^^xsd:float',
            '?long > "' + llon + '"^^xsd:float'
        ].join ' && '
        next null, true
