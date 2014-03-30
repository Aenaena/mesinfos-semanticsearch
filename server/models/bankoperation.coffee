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