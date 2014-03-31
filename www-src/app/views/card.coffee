BaseView = require '../lib/base_view'

module.exports = class CardView extends BaseView

    tagName: 'a'
    className: 'card'
    template: require '../templates/card'
    events:
        'click ': 'toggleSelected'

    getRenderData: ->
        _.extend {title:'', content:''}, @model.getSummary()

    toggleSelected: (event) =>
        if @model.get('_id')
            app.router.navigate 'around/' + @model.get('_id'), true
        else if @model.get('lat')
            url = "http://www.openstreetmap.org/#map=19/"
            url += @model.get('lat') + '/' + @model.get('long')
            window.open url, '_blank'

    centerPos: ->
        {left, top} = @$el.position()
        left += @$el.width() / 2
        top += @$el.height() / 2
        return {left, top}
