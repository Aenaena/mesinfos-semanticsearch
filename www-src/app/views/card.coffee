BaseView = require '../lib/base_view'

module.exports = class CardView extends BaseView

    tagName: 'a'
    className: 'card'
    template: require '../templates/card'
    events:
        'click ': 'toggleSelected'

    getRenderData: ->
        _.extend {title:'', content:''}, @model.getSummary()

    toggleSelected: (event) ->
        @$el.toggleClass 'selected'
        if @$el.hasClass 'selected'
            @$el.append $('<div class="more">').text('Plus d\'info').slideDown()
        else
            @$('.more').slideUp -> @$('.more').remove()

    centerPos: ->
        {left, top} = @$el.position()
        left += @$el.width() / 2
        top += @$el.height() / 2
        return {left, top}
