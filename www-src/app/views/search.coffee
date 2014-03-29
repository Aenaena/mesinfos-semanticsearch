BaseView = require '../lib/base_view'

module.exports = class FolderView extends BaseView

    className: 'navbar navbar-inverse navbar-fixed-top'
    template: require '../templates/search'

    setContent: (text) ->
        @$('input').val text