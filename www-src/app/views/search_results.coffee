ViewCollection = require '../lib/view_collection'
SearchCollection = require '../collections/search_results'

module.exports = class SearchResults extends ViewCollection

    id: 'result-view'
    className: 'container-fluid'
    counter: 0
    itemview: require './card'

    initialize: (options) ->
        @collection = new SearchCollection [], options
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

        for link in @collection.links
            linkTo = if view.model.cid is link.s then @views[link.o]
            else if view.model.cid is link.o then linkTo = @views[link.s]
            else null

            if linkTo
                me = view.centerPos()
                lt = linkTo.centerPos()
                @lines.append @createSVG 'line',
                    x1: me.left, y1: me.top
                    x2:lt.left, y2:lt.top
                    style:'stroke:#ddd;stroke-width:2'

    afterRender: ->
        super
        @$el.height $('body').height()
        @$el.append @lines.attr width: @$el.width(), height:@$el.height()