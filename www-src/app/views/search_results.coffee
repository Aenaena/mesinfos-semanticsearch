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

    overlaps: (top, left) ->
        for cid, view of @views
            v = view.$el.position()
            return true if Math.abs(v.left - left) + Math.abs(v.top - top) < 1

        return false

    appendView: (view) ->
        links = @collection.links.map (l) => s:@collection.get(l.s).cid, o:@collection.get(l.o).cid
        console.log(links)
        links = links.filter (l) -> view.model.cid in [l.s, l.o]
        console.log links
        links = links.map (l) -> if l.s is view.model.cid then l.o else l.s
        console.log links
        views = links.map((cid) => @views[cid]).filter (x) -> not not x
        console.log views


        if views.length
            # there is some links, figure where to place it
            {top, left} = views[0].$el.position()
            # top -= 100
            left += 350
            while @overlaps top, left
                top += 100

        else
            left = 50
            top = @maxTop + 100


        view.$el.css {top, left}
        @maxTop = top if top > @maxTop
        @maxLeft = left if left > @maxTop
        @$el.height @maxTop + 500
        @$el.width @maxLeft + 500
        @lines.attr width: @$el.width(), height:@$el.height()
        @$el.append @lines

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