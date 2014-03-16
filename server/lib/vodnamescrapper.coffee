request = require 'request'

module.exports = (work, callback)->
    request "http://rp-vod.woopic.com/vod-webapp/catalog/vod/detailedContent/" + work + ".json",
    (error, response, body)-> 
        return callback error if error
        console.log typeof body
        body = JSON.parse body
        callback null, body.response.title