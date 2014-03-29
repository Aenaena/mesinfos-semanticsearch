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
    return false unless this.type is 'VOICE'
    graph = rdf.makeGraph()
    nodeName = rdf.modelName this
    graph.add rdf.makeTriple nodeName, "a", "pcrd:PhoneCommunicationLog"
    graph.add rdf.makeTriple nodeName, "pcrd:hasCorrespondantNumber", "tel:+#{this.correspondantNumber}"
    rdf.addDuration graph, this, "seconds", this.chipCount
    rdf.addPosition graph, this, this.latitude, this.longitude
    rdf.addDatetime graph, this, new Date(this.timestamp)
    return graph