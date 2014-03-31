request = require 'request'
endpoint = 'http://dbpedia.org/sparql'

module.exports = (query, callback)->
    request endpoint + '/' + query
    (error, response, body)->
        return callback error if error
        body = JSON.parse body
        callback null, body.response.title