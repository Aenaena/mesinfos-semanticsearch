# build an index
Contact = require '../models/Contact'
Link = require '../models/link'
async = require 'async'
iterator = require '../lib/iterator'
indexer = require '../lib/indexer'

module.exports =

    index: true,

    onCreated: (contact, callback) ->
        async.each contact.datapoints or [], (dp, cb) ->
            return callback null unless dp.name in ['tel', 'email']
            Link.make "#{dp.name}:#{dp.value}", "is", contact, cb

