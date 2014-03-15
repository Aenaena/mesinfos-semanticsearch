Contact = require '../server/models/contact'
Link = require '../server/models/link'
async = require 'async'
iterator = require '../server/lib/iterator'
indexer = require '../server/lib/indexer'
root = require('path').join __dirname, '..'
require 'should'


describe "Links", ->

    before (done) ->
        require('americano-cozy').configure root, null, done
    before (done) ->
        Contact.requestDestroy 'all', done
    before (done) ->
        Link.requestDestroy 'all', done

    it "Creates a contact", (done) ->
        Contact.create fn: 'John Doe', (err, contact) =>
            @john = contact
            done(err)

    it "Creates another contact", (done) ->
        Contact.create fn: 'Jane Martinez Doe', (err, contact) =>
            @jane = contact
            done(err)

    it "Create links", (done) ->
        Link.make @john, 'is-a', 'human', (err) =>
            return done err if err
            Link.make @john, 'friend-of', @jane, (err) ->
                return done err if err
                done()

    it "Can search links", (done) ->
        Link.getTo @jane, (err, results) ->
            results[0].concept.fn.should.equal 'John Doe'
            done()


describe "Iterator", ->

    it "Create another 10 contacts", (done) ->
        async.each [1..10], (i, cb) ->
            Contact.create fn: "Bob #{i}", cb
        , done


    it "Iterate properly by batch", (done) ->
        cnt = 0
        iterator.batch 3, Contact, (models, cb) ->
            models.length.should.equal 3
            cnt += models.length
            cb()
        , (err) ->
            cnt.should.equal 12
            done()

describe "Initializer", ->

    it "Do not explode", (done) ->
        @timeout 15000
        initialize = require "../server/initialize"
        initialize done

describe "Search", ->

    it "works", (done) ->
        indexer.search "martinez", done
