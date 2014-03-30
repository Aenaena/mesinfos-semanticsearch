async = require 'async'
path = require 'path'
root = path.join __dirname, '..'
indexer = require '../server/lib/indexer'
require 'should'


describe "Initializer", ->

    before (done) ->
        @timeout 60000
        require('americano-cozy').configure root, null, done

    # before (done) ->
    #     @timeout 60000
    #     require('cozy-fixtures').load
    #         dirPath: path.join root, 'tests/fixtures'
    #         silent: true
    #         callback: done


    it "Do not explode", (done) ->
        @timeout 15000
        initialize = require "../server/initialize"
        initialize done

# describe "Iterator", ->
#     Contact = require '../server/models/contact'

#     it "Iterate properly by batch", (done) ->
#         cnt = 0
#         iterator.batch 9, Contact, (models, cb) ->
#             models.length.should.equal 9
#             cnt += models.length
#             cb()
#         , (err) ->
#             cnt.should.equal 747
#             done()


    # it "Sparkles", (done) ->
    #     store = require('../server/models/rdf_storage').store

    #     store.graph (success, graph) ->
    #         # graph.triples.forEach (t) ->
    #              # console.log t.subject.nominalValue, t.predicate.nominalValue, t.object.nominalValue

    #         query = """
    #             PREFIX foaf: <http://xmlns.com/foaf/0.1/>
    #             PREFIX pcrd: <http://www.techtane.info/phonecommunicationlog.ttl#>
    #             PREFIX time: <http://www.w3.org/2006/time#>
    #             SELECT ?contact ?duration ?month
    #             WHERE {
    #                 ?contact <a> foaf:Person.
    #                 ?contact foaf:phone ?tel.
    #                 ?log <a> pcrd:PhoneCommunicationLog.
    #                 ?log pcrd:hasCorrespondantNumber ?tel.
    #                 ?log time:hasInstant ?begin.
    #                 ?begin time:inDateTime ?begindtd.
    #                 ?begindtd time:month ?month.
    #                 ?log time:hasDuration ?durationObj.
    #                 ?durationObj time:seconds ?duration.
    #             }
    #         """

    #         store.execute query, (success, results) ->
    #             console.log success, results
    #         done()


describe "Search", ->

    it "works", (done) ->
        indexer.search "martin", (err, msg) ->
            console.log msg.hits
            done(err)
