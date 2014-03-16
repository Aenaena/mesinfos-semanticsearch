americano = require 'americano-cozy'

module.exports = Contact = americano.getModel 'contact',
    fn            : String # vCard FullName = display name
    n             : String # vCard Name = splitted
    datapoints    : (x) -> x
    note          : String
    tags          : (x) -> x
    _attachments  : Object


Contact.batchSize = 100
Contact.indexFields = ['n', 'fn', 'note', 'tags']
