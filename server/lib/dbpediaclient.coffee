request = require 'request'
endpoint = 'http://dbpedia.org/sparql'
# Pass a regular SPARQL query.
# This routine encode it and queries dbpedia.
# Results are returned in XML.
module.exports = (query, callback)->
    encodedQuery = urlEncode(query)
    request endpoint + '/' + encodedQuery
    (error, response, body)->
        return callback error if error
        callback null, body
