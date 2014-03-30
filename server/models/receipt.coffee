americano = require 'americano-cozy'

module.exports = Receipt = americano.getModel 'receipt',
    'receiptId': String,
    'transactionCode': String,
    'transaction': String,
    'transactionId': String,
    'timestamp': Date,
    'checkoutId': String,
    'checkoutReceiptId': String,
    'cashierId': String,
    'articlesCount': Number,
    'amount': Number,
    'loyaltyBalance': Number,
    'convertedPoints': Number,
    'acquiredPoints': Number,
    'intermarcheShopId': String,
    'total': Number,
    'paidAmound': Number,
    'isOnline': Boolean,
    'snippet': String

Receipt.batchSize = 100
Receipt.indexFields = []

Receipt::toRDFGraph = (rdf) ->
    graph = rdf.makeGraph()
    date = new Date(this.timestamp)
    nodeName = rdf.modelName this
    graph.add rdf.makeTriple nodeName, "a", "rcp:Receipt"
    graph.add rdf.makeTriple nodeName, "rcp:hasArticlesCount", rdf.makeInt this.articlesCount
    graph.add rdf.makeTriple nodeName, "rcp:hasPaidAmount", rdf.makeInt this.total
    graph.add rdf.makeTriple nodeName, "rcp:hasOriginCompany", 'dbpedia-fr:Intermarché'
    rdf.addDatetime graph, this, new Date(this.timestamp)
    return graph