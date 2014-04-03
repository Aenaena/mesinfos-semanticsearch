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

Contact::aroundSPARQL = ->
    """
    PREFIX foaf: <http://xmlns.com/foaf/0.1/>
    PREFIX prcd: <http://www.techtane.info/phonecommunicationlog.ttl#>
    PREFIX time: <http://www.w3.org/2006/time#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX my: <https://my.cozy.io/>
    SELECT ?person ?tel ?log ?instant ?mail
    WHERE {
        ?person <a> foaf:Person
        OPTIONAL {
            ?person foaf:phone ?tel .
        }
        OPTIONAL {
            ?log prcd:hasCorrespondantNumber ?tel .
            ?log <a>/rdfs:subClassOf prcd:PhoneCommunicationLog .
            ?log time:hasInstant/time:inDateTime ?instant .
        }
        OPTIONAL {
            ?person foaf:mbox ?mail
        }
        FILTER(?person = my:#{@_id}) .
    }
    """