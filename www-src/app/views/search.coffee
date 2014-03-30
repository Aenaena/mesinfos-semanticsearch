BaseView = require '../lib/base_view'

module.exports = class FolderView extends BaseView

    className: 'navbar navbar-inverse navbar-fixed-top'
    template: require '../templates/search'
    events:
        'keydown input': 'onKeyDown'

    setContent: (text) ->
        @$('input').val text

    onKeyDown: (event) ->
        if event.which is 13
            url = "search/" + encodeURIComponent @$('input').val()
            app.router.navigate url, trigger: true