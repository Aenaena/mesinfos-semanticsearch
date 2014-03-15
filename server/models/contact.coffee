americano = require 'americano-cozy'

module.exports = Contact = americano.getModel 'Contact',
    id            : String
    fn            : String # vCard FullName = display name
    n             : String # vCard Name = splitted
    datapoints    : (x) -> x
    note          : String
    tags          : (x) -> x
    _attachments  : Object


Contact.batchSize = 100
Contact.indexFields = ['n', 'fn', 'note', 'tags']

Contact::get2FN = ->
    return @fn + @fn