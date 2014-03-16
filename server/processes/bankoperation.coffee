# build an index
BankOperation = require '../models/bankoperation'
Link = require '../models/link'
async = require 'async'

module.exports =

    index: true,

    onCreated: (operation, callback) ->