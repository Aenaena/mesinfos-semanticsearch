Router = require './router'
SearchView = require './views/search'

# initiliaze app on documentready

module.exports = app =

    initialize: ->

        window.app = this

        Date.setLocale 'fr'

        Router = require 'router'
        @router = new Router()

        @header = new SearchView().render()
        $('body').empty().append @header.$el

        Backbone.history.start()

$ -> app.initialize()