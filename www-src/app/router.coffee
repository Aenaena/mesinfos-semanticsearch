HomeView = require './views/home'
SearchResultView = require './views/search_results'

module.exports = class Router extends Backbone.Router

    routes:
        '': 'home'
        'search/*query': 'query'

    home: ->
        app.header.setContent ""
        @displayView new HomeView()

    query: (search) ->
        app.header.setContent decodeURIComponent(search)
        @displayView new SearchResultView query: search

    displayView: (view) ->
        @mainView.remove() if @mainView
        $('body').append view.$el
        @mainView = view.render()