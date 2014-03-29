BaseView = require '../lib/base_view'

module.exports = class CardView extends BaseView

    tagName: 'a'
    className: 'card'
    template: require '../templates/card'
    events:
        'click ': 'toggleSelected'

    getRenderData: -> _.extend {title:'', content:''}, @model.getSummary()


    toggleSelected: (event) ->
        @$el.toggleClass 'selected'