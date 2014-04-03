module.exports = class DateModel extends Backbone.Model

    constructor: (value) ->
        super value: value, id: value

    getSummary:  ->
        title: @get('value')
        image: 'img/date.png'