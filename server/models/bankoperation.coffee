americano = require 'americano-cozy'

module.exports = BankOperation = americano.getModel 'bankoperation',
    bankAccount: String
    title: String
    date: Date
    amount: Number
    raw: String
    dateImport: Date

BankOperation.batchSize = 100
BankOperation.indexFields = []

BankOperation::toRDFGraph = (rdf) ->
    graph = rdf.makeGraph()
    nodeName = rdf.modelName this

    isOutbound = (@amount < 0).toString()

    graph.add rdf.makeTriple nodeName, "a", "bko:BankOperation"
    graph.add rdf.makeTriple nodeName, "bko:hasAmount", rdf.makeInt @amount
    graph.add rdf.makeTriple nodeName, "pdta:isOutbound", isOutbound
    rdf.addDatetime graph, this, new Date(this.date)
    return graph

BankOperation::aroundSPARQL = ->
    """
    PREFIX bko: <http://www.techtane.info/bankoperation.ttl#>
    PREFIX time: <http://www.w3.org/2006/time#>
    PREFIX my: <https://my.cozy.io/>
    SELECT ?bankoperation ?instant
    WHERE {
        ?bankoperation <a> bko:BankOperation .
        ?bankoperation time:hasInstant/time:inDateTime ?instant .
        FILTER(?bankoperation = my:#{@_id}) .
    }
    """
