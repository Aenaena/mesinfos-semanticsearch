ViewCollection = require '../lib/view_collection'
SearchCollection = require '../collections/search_results'

module.exports = class SearchResults extends ViewCollection

    id: 'result-view'
    className: 'container-fluid'
    counter: 0
    itemview: require './card'

    initialize: (options) ->
        @collection = new SearchCollection [], options
        @collection.on 'error', -> alert 'Reformulez votre requête.'
        @lines = @createSVG 'svg', {}
        super

    createSVG: (tagName, attr) ->
        elem = window.document.createElementNS('http://www.w3.org/2000/svg', tagName)
        $(elem).attr(attr)


    appendView: (view) ->
        view.$el.css
            top: 50 + 10*@counter++
            left: 350*@counter
        super
        @collection.links.filter((l) -> view.model.cid in [l.s, l.o]
        ).map((l) -> if l.s is view.model.cid then l.o else l.s
        ).forEach (cid) =>
            return unless @views[cid]
            a = @views[cid].centerPos()
            b = view.centerPos()
            @lines.append @createSVG 'line',
                x1: a.left, y1: a.top
                x2: b.left, y2: b.top
                style:'stroke:#ddd;stroke-width:2;'

    afterRender: ->
        super
        @$el.height $('body').height()
        @$el.append @lines.attr width: @$el.width(), height:@$el.height()