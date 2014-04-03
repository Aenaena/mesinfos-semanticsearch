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
    graph.add rdf.makeTriple nodeName, "rcp:hasReceiptId", rdf.makeString @receiptId
    graph.add rdf.makeTriple nodeName, "rcp:hasReceiptId", rdf.makeString @receiptId.slice(0,-1)
    graph.add rdf.makeTriple nodeName, "rcp:hasPaidAmount", rdf.makeFloat this.total
    graph.add rdf.makeTriple nodeName, "rcp:hasOriginCompany", 'dbpedia-fr:Intermarché'
    rdf.addDatetime graph, this, new Date(this.timestamp)
    return graph

Receipt::aroundSPARQL = ->
    """
    PREFIX rcpd: <http://www.techtane.info/receiptdetail.ttl#>
    PREFIX rcp: <http://www.techtane.info/receipt.ttl#>
    PREFIX time: <http://www.w3.org/2006/time#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX my: <https://my.cozy.io/>
    SELECT ?instant ?receipt ?family ?product
    WHERE {
        ?receipt rcp:hasReceiptId ?id .
        ?product rcpd:hasReceiptId ?id .
        ?receipt time:hasInstant/time:inDateTime ?instant .
        ?product rcpd:hasFamilyLabel ?family .
        FILTER(?receipt = my:#{@_id}) .
    }
    ORDER BY ?family
    """