americano = require 'americano-cozy'

module.exports = PhoneCommunicationLog = americano.getModel 'phonecommunicationlog',
    'origin': String
    'idMesInfos': String
    'direction': String
    'timestamp': Date
    'subscriberNumber': String
    'correspondantNumber': String
    'chipCount': Number
    'chipType': String
    'type': String
    'imsi': { 'type': String, 'default': null }
    'imei': { 'type': String, 'default': null }
    'latitude': Number
    'longitude': Number
    'snippet': String

PhoneCommunicationLog.batchSize = 100
PhoneCommunicationLog.indexFields = []

PhoneCommunicationLog::toRDFGraph = (rdf) ->

    klass = if this.type is 'VOICE' then 'prcd:PhoneCall'
    else if this.type is 'SMS-C' then 'prcd:TextMessage'
    else false


    return false unless klass

    graph = rdf.makeGraph()
    nodeName = rdf.modelName this
    graph.add rdf.makeTriple nodeName, "a", klass
    graph.add rdf.makeTriple nodeName, "prcd:hasCorrespondantNumber", "tel:+#{this.correspondantNumber}"
    graph.add rdf.makeTriple nodeName, "pdta:isOutbound", (@direction is 'OUTGOING').toString()
    rdf.addDuration graph, this, "seconds", this.chipCount
    rdf.addPosition graph, this, this.latitude, this.longitude
    rdf.addDatetime graph, this, new Date(this.timestamp)
    return graph


PhoneCommunicationLog::aroundSPARQL = ->
    """
    PREFIX foaf: <http://xmlns.com/foaf/0.1/>
    PREFIX prcd: <http://www.techtane.info/phonecommunicationlog.ttl#>
    PREFIX time: <http://www.w3.org/2006/time#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>
    PREFIX my: <https://my.cozy.io/>
    SELECT ?person ?tel ?log ?instant ?point
    WHERE {
        ?log <a>/rdfs:subClassOf prcd:PhoneCommunicationLog .
        ?log prcd:hasCorrespondantNumber ?tel .
        ?log time:hasInstant/time:inDateTime ?instant .
        OPTIONAL { ?person foaf:phone ?tel . }
        OPTIONAL { ?log geo:location ?point  . }
        FILTER(?log = my:#{@_id}) .
    }
    """
