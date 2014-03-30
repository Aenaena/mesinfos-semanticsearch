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

    console.log klass

    graph = rdf.makeGraph()
    nodeName = rdf.modelName this
    graph.add rdf.makeTriple nodeName, "a", klass
    graph.add rdf.makeTriple nodeName, "prcd:hasCorrespondantNumber", "tel:+#{this.correspondantNumber}"
    graph.add rdf.makeTriple nodeName, "pdta:isOutbound", (@direction is 'OUTGOING').toString()
    rdf.addDuration graph, this, "seconds", this.chipCount
    rdf.addPosition graph, this, this.latitude, this.longitude
    rdf.addDatetime graph, this, new Date(this.timestamp)
    return graph