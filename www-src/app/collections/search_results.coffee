BaseModel = require '../models/base'
DateModel = require '../models/date'

module.exports = class SearchCollection extends Backbone.Collection

    model: BaseModel

    initialize: (items, options) ->

        if options.around
            options.sparql = """
                PREFIX my: <https://my.cozy.io/>
                SELECT ?linked
                WHERE {
                    {?linked ?p my:#{options.around} . }
                    UNION
                    {my:#{options.around} ?p ?linked .}
                }
            """

        if options.query
            @fetch url: "semantic/nlp?query=" + encodeURIComponent options.query

        else if options.sparql
            @fetch
                url: "semantic/sparql"
                method: 'POST'
                contentType: 'text/sparql'
                data: options.sparql



    parse: (data) ->
        models = []
        links = []

        for match in data.semantic
            dict = {}
            for token, node of match
                if node.token is 'uri'
                    id = node.value.replace('https://my.cozy.io/', '')
                    # console.log id, data.docs[id]
                    if id.substr(0, 8) is 'instant/'
                        [date, hour] = id.substr(8).split('T')
                        hour = hour.replace /-/g, ':'
                        models.push model = new DateModel date + 'T' + hour
                        dict[token] = model.cid

                    else
                        models.push model = new BaseModel data.docs[id]
                        dict[token] = model.cid

            links = links.concat data.links.map (l) ->
                s: dict[l.s], o: dict[l.o]

        if data.semantic.length is 0
            models.push new BaseModel docType: 'error', error: 'No results'

        @links = links

        return models