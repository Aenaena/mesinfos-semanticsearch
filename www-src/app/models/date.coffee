module.exports = class DateModel extends Backbone.Model

    constructor: (value) ->
        super value: new Date(value)

    getSummary:  ->
        title: @get('value').format('short')
        image: 'img/date.png'
        content: @get('value').format