module.exports = class DateModel extends Backbone.Model

    constructor: (value) ->
        date = new Date(value)
        super value: date, id: date.format('long')

    getSummary:  ->
        title: @get('value').format('short')
        image: 'img/date.png'
        content: @get('value').format('{HH}:{mm}')