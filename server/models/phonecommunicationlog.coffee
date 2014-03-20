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

PhoneCommunicationLog::toRDFGraph = (store) ->
    return false unless this.type is 'VOICE'
    graph = store.newGraph()
    date = new Date(this.timestamp)
    nodeName = store.modelName this
    graph.add store.makeTriple nodeName, "a", "pcrd:PhoneCommunicationLog"
    graph.add store.makeTriple nodeName, "pcrd:hasCorrespondantNumber", "tel:+#{com.correspondantNumber}"
    store.addDuration graph, this, "seconds", this.chipCount
    store.addPosition graph, this, this.latitude, this.longitude
    # store.addDatetime graph, com, date
    return graph