ViewCollection = require '../lib/view_collection'
SearchCollection = require '../collections/search_results'

module.exports = class SearchResults extends ViewCollection

    className: 'container'
    itemview: require './card'

    initialize: (options) ->
        @collection = new SearchCollection [], options
        super