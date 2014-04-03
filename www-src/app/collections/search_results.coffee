BaseModel = require '../models/base'
DateModel = require '../models/date'
ValueModel = require '../models/value'
GeoModel = require '../models/geo'

module.exports = class SearchCollection extends Backbone.Collection

    model: BaseModel
    links: {}

    initialize: (items, options) ->

        if options.around
            @fetch reset: true, url: "semantic/around?id=" + options.around

        if options.query
            @fetch reset: true, url: "semantic/nlp?query=" + encodeURIComponent options.query


    getPlacementInfo: (id) ->
        model = @get
        links = @links[id].map (otherId) -> @get otherId


    addLink: (s, o) ->
        (@links[s.id] ?= []).push o.id
        (@links[o.id] ?= []).push s.id

    parse: (data) ->

        models = []
        links = []

        for match in data.semantic
            dict = {}
            for token, node of match
                model = null
                if node?.token is 'uri'
                    id = node.value.replace('https://my.cozy.io/', '')
                    # console.log id, data.docs[id]
                    if id.substr(0, 8) is 'instant/'
                        [date, hour] = id.substr(8).split('T')
                        hour = hour.replace /-/g, ':'
                        models.push model = new DateModel date + 'T' + hour
                        dict[token] = model.id = id

                    else if id.substr(0, 9) is 'position/'
                        [lat, long] = id.substr(9).split('-').map parseFloat
                        models.push model = new GeoModel lat, long
                        dict[token] = model.id = Math.random()*10000000

                    else if id.substr(0,4) is 'tel:'
                        models.push model = new BaseModel title: id.substr(4)
                        dict[token] = model.id = id.substr(4)

                    else if id.substr(0,7) is 'mailto:'
                        models.push model = new BaseModel title: id.substr(7)
                        dict[token] = model.id = id.substr(7)

                    else
                        models.push model = new BaseModel data.docs[id]
                        dict[token] = model.id = id

                else if node?.token is 'literal'
                    models.push model = new ValueModel node.value
                    dict[token] = model.id

            console.log dict

            links = links.concat data.links.map((l) ->
                s: dict[l.s], o: dict[l.o]
            ).filter (l) -> l.s and l.o

        console.log links

        if data.semantic.length is 0
            models.push new BaseModel docType: 'error', error: 'No results'

        @links = links

        return models