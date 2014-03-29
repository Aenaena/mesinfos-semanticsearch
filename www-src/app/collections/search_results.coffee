BaseModel = require '../models/base'
DateModel = require '../models/date'

module.exports = class SearchCollection extends Backbone.Collection

    model: BaseModel

    initialize: (items, options) ->

        if options.query
            @fetch url: "semantic/nlp?query=" + encodeURIComponent options.query

    parse: (data) ->
        models = []
        @links = []
        for match in data.semantic

            inGroup = []
            for token, node of match
                if node.token is 'uri'
                    id = node.value.replace('https://my.cozy.io/', '')
                    # console.log id, data.docs[id]
                    if id.substr(0, 8) is 'instant/'
                        [date, hour] = id.substr(8).split('T')
                        hour = hour.replace /-/g, ':'
                        inGroup.push new DateModel date + 'T' + hour
                    else
                        inGroup.push new BaseModel data.docs[id]

            for a in inGroup then for b in inGroup when a isnt b
                link = s: a.cid, o: b.cid
                exist = _.findWhere(@links, link) or _.findWhere @links, o: a.cid, s: b.cid
                console.log link, exist
                @links.push link unless exist


            models = models.concat inGroup


        return models