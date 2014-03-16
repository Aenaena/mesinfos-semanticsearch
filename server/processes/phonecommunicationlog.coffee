# build an index
Contact = require '../models/Contact'
Link = require '../models/link'
async = require 'async'
store = require '../store'

module.exports =

    index: true,

    onCreated: (com, callback) ->
        return callback null unless com.type is 'VOICE'
        id = com.id
        graph = store.newGraph()
        date = new Date(com.timestamp)
        nodeName = store.modelName com
        graph.add store.makeTriple nodeName, "a", "pdta:PhoneCommunication"
        store.addDuration graph, com, "seconds", com.chipCount
        # store.addDatetime graph, com, date
        store.insert graph, callback