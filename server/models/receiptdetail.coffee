americano = require 'americano-cozy'

module.exports = ReceiptDetail = americano.getModel 'receiptdetail',
    'origin': String,
    'order': Number,
    'barcode': String,
    'label': String,
    'family': String,
    'familyLabel': String,
    'section': String,
    'sectionLabel': String,
    'amount': Number,
    'price': Number,
    'type': String,
    'typeLabel': String,
    'receiptId': String,
    'intermarcheShopId': String,
    'timestamp': Date,
    'isOnlineBuy': Boolean,

ReceiptDetail.batchSize = 100
ReceiptDetail.indexFields = []

ReceiptDetail::toRDFGraph = () ->
    return false unless this.type is 'VOICE'
    graph = rdf.newGraph()
    nodeName = rdf.modelName this
    graph.add rdf.makeTriple nodeName, "a", "rcpd:ReceiptDetail"
    # rdf.addDatetime graph, com, new Date(this.timestamp)
    return graph

