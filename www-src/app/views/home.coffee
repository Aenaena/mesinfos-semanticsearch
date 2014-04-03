BaseView = require '../lib/base_view'

module.exports = class HomeView extends BaseView

    className: 'jumbotron'
    template: require '../templates/home'

    getRenderData: ->
        noaccent: require '../lib/noaccent'