BaseModel = require '../models/base'
DateModel = require '../models/date'

module.exports = class SearchCollection extends Backbone.Collection

    model: BaseModel

    initialize: (items, options) ->

        if options.query
            @fetch url: "semantic/nlp?query=" + encodeURIComponent options.query

    parse: (data) ->
        models = []
        for match in data.semantic
            for token, node of match
                if node.token is 'uri'
                    id = node.value.replace('https://my.cozy.io/', '')
                    console.log "THERE", id
                    if id.substr(0, 8) is 'instant/'
                        console.log 'INSTANT'
                        [date, hour] = id.substr(8).split('T')
                        hour = hour.replace /-/g, ':'
                        models.push new DateModel date + 'T' + hour
                    else
                        models.push new BaseModel data.docs[id]

        return models