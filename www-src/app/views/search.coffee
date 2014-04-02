BaseView = require '../lib/base_view'
noaccent = require '../lib/noaccent'

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
            url = "search/" + encodeURIComponent noaccent @$('input').val()
            app.router.navigate url, trigger: true