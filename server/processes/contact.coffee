# build an index
Contact = require '../models/Contact'
store = require '../store'
async = require 'async'

module.exports =

    index: true,

    onCreated: (contact, callback) ->
        return callback null

        graph = store.newGraph()
        nodeName = store.modelName contact
        for dp in (contact.datapoints or [])
            if dp.name is 'tel'
                graph.add store.makeTriple nodeName, "foaf:phone", "tel:#{dp.value}"
            else if dp.name is 'email'
                graph.add store.makeTriple nodeName, "foaf:mbox", "mailto:#{dp.value}"

        store.insert graph, callback