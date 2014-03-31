BaseView = require '../lib/base_view'

module.exports = class FolderView extends BaseView

    className: 'navbar navbar-inverse navbar-fixed-top'
    template: require '../templates/search'
    events:
        'keydown input': 'onKeyDown'
        'click #back-btn': 'back'

    setContent: (text) ->
        @$('input').val text

    back: (e) ->
        window.history.back()
        e.preventDefault()

    onKeyDown: (event) ->
        if event.which is 13
            url = "search/" + encodeURIComponent @$('input').val()
            app.router.navigate url, trigger: true