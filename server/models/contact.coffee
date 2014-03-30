americano = require 'americano-cozy'

module.exports = Contact = americano.getModel 'contact',
    fn            : String # vCard FullName = display name
    n             : String # vCard Name = splitted
    datapoints    : (x) -> x
    note          : String
    tags          : (x) -> x
    _attachments  : Object


Contact.batchSize = 100
Contact.indexFields = ['n', 'fn']

Contact::toRDFGraph = (rdf) ->
    graph = rdf.makeGraph()
    nodeName = rdf.modelName this
    graph.add rdf.makeTriple nodeName, "a", "foaf:Person"
    graph.add rdf.makeTriple nodeName, "foaf:name", this.fn
    # graph.add rdf.makeTriple nodeName, 'rdfs:label', rdf.makeLiteral this.fn
    for dp in (this.datapoints or [])
        if dp.name is 'tel'
            graph.add rdf.makeTriple nodeName, "foaf:phone", "tel:#{dp.value}"
        else if dp.name is 'email'
            graph.add rdf.makeTriple nodeName, "foaf:mbox", "mailto:#{dp.value}"

    return graph
