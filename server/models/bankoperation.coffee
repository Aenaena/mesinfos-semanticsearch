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
    return false unless this.type is 'VOICE'
    graph = rdf.makeGraph()
    nodeName = rdf.modelName this
    graph.add rdf.makeTriple nodeName, "a", "bko:BankOperation"
    graph.add rdf.makeTriple nodeName, "bko:hasAmount", rdf.makeInt @amount
    rdf.addDatetime graph, this, new Date(this.date)
    return graph