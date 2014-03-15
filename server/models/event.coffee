americano = require 'americano-cozy'

module.exports = Event = americano.getModel 'Event',
    start       : type : String
    end         : type : String
    place       : type : String
    # @TODO : rename those to follow ical (NEED PATCH)
    details     : type : String # = ical DESCRIPTION
    description : type : String # = ical SUMMARY
    diff        : type : Number
    rrule       : type : String
    tags        : type : (x) -> x # DAMN IT JUGGLING
    attendees   : type : [Object]
    related: type: String, default: null