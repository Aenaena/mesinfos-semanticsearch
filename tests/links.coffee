Contact = require '../server/models/contact'
async = require 'async'
iterator = require '../server/lib/iterator'
indexer = require '../server/lib/indexer'
path = require 'path'
root = path.join __dirname, '..'
require 'should'


describe "Links", ->

    before (done) ->
        require('americano-cozy').configure root, null, done
    before (done) ->
        require('cozy-fixtures').load
            dirPath: path.join root, 'test/fixtures'
            silent: true
            callback: done

# describe "Iterator", ->

#     it "Create another 10 contacts", (done) ->
#         async.each [1..10], (i, cb) ->
#             Contact.create fn: "Bob #{i}", cb
#         , done


#     it "Iterate properly by batch", (done) ->
#         cnt = 0
#         iterator.batch 3, Contact, (models, cb) ->
#             models.length.should.equal 3
#             cnt += models.length
#             cb()
#         , (err) ->
#             cnt.should.equal 12
#             done()

describe "Initializer", ->

    it "Do not explode", (done) ->
        @timeout 15000
        initialize = require "../server/initialize"
        initialize done

describe "Search", ->

    it "works", (done) ->
        indexer.search "martinez", done
