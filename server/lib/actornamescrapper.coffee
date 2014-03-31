request = require 'request'

# Orange API already return actors... let's ask dbpedia for more about them!
module.exports = (work, callback)->
    request "http://rp-vod.woopic.com/vod-webapp/catalog/vod/detailedContent/" + work + ".json",
    (error, response, body)->
        return callback error if error
        body = JSON.parse body
        # JSON with first name and last name for each actor :
        #    "actors": [
        #    {
        #        "firstName": "Blake",
        #        "lastName": "Lively",
        #        "character": ""
        #    },
        #    {
        #        "firstName": "Leighton",
        #        "lastName": "Meester",
        #        "character": ""
        #    },
        #    {
        #        "firstName": "Ed",
        #        "lastName": "Westwick",
        #        "character": ""
        #    },
        #    {
        #        "firstName": "Penn",
        #        "lastName": "Badgley",
        #        "character": ""
        #    }
        callback null, body.response.actors
