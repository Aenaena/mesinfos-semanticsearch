americano = require 'americano-cozy'
rdf = require '../lib/storetools'

module.exports = Contact = americano.getModel 'contact',
    fn            : String # vCard FullName = display name
    n             : String # vCard Name = splitted
    datapoints    : (x) -> x
    note          : String
    tags          : (x) -> x
    _attachments  : Object


Contact.batchSize = 100
Contact.indexFields = ['n', 'fn', 'note', 'tags']

Contact::toRDFGraph = () ->
    graph = rdf.newGraph()
    nodeName = rdf.modelName contact
    graph.add rdf.makeTriple nodeName, "a", "foaf:Person"
    graph.add rdf.makeTriple nodeName, "foaf:name", contact.fn
    for dp in (contact.datapoints or [])
        if dp.name is 'tel'
            graph.add rdf.makeTriple nodeName, "foaf:phone", "tel:#{dp.value}"
        else if dp.name is 'email'
            graph.add rdf.makeTriple nodeName, "foaf:mbox", "mailto:#{dp.value}"

    return graph
