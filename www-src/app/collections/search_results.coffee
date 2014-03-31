BaseModel = require '../models/base'
DateModel = require '../models/date'
GeoModel = require '../models/geo'

module.exports = class SearchCollection extends Backbone.Collection

    model: BaseModel

    initialize: (items, options) ->

        if options.around
            @fetch url: "semantic/around?id=" + options.around

        if options.query
            @fetch url: "semantic/nlp?query=" + encodeURIComponent options.query

    parse: (data) ->

        console.log "DATA", data
        models = []
        links = []

        for match in data.semantic
            dict = {}
            for token, node of match
                if node?.token is 'uri'
                    id = node.value.replace('https://my.cozy.io/', '')
                    # console.log id, data.docs[id]
                    if id.substr(0, 8) is 'instant/'
                        [date, hour] = id.substr(8).split('T')
                        hour = hour.replace /-/g, ':'
                        models.push model = new DateModel date + 'T' + hour
                        dict[token] = model.cid

                    else if id.substr(0, 9) is 'position/'
                        [lat, long] = id.substr(9).split('-').map parseFloat
                        models.push model = new GeoModel lat, long
                        dict[token] = model.cid

                    else if id.substr(0,4) is 'tel:'
                        models.push new BaseModel title: id
                        dict[token] = model.cid

                    else
                        console.log id
                        models.push model = new BaseModel data.docs[id]
                        dict[token] = model.cid

            links = links.concat data.links.map (l) ->
                s: dict[l.s], o: dict[l.o]

        if data.semantic.length is 0
            models.push new BaseModel docType: 'error', error: 'No results'

        @links = links

        return models