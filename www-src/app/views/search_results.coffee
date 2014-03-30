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
        links = @collection.links.filter (l) -> view.model.cid in [l.s, l.o]
        links = links.map (l) -> if l.s is view.model.cid then l.o else l.s
        views = links.map((cid) => @views[cid]).filter (x) -> not not x

        if views.length
            # there is some links, put it on the right
            {top, left} = views[0].$el.position()
            left += 350

            @maxLeft = Math.max(left, @maxLeft)
            @$el.width @maxLeft + 500

        else
            left = 50
            @maxTop = top = @maxTop + 100
            @$el.height @maxTop + 500


        @$el.append @lines.attr width: @$el.width(), height:@$el.height()

        view.$el.css {top, left}
        super
        views.forEach (linked) =>
            a = linked.centerPos()
            b = view.centerPos()
            @lines.append @createSVG 'line',
                x1: a.left, y1: a.top
                x2: b.left, y2: b.top
                style:'stroke:#ddd;stroke-width:2;'

    afterRender: ->
        @maxTop  = -50
        @maxLeft = 0
        super