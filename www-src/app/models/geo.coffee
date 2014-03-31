module.exports = class DateModel extends Backbone.Model

    constructor: (lat, long) ->
        super {lat, long}

    getSummary:  ->
        title: 'Position'
        image: 'img/geo.png'
        content: @get('lat') + ';' + @get('long')