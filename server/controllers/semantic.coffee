RDFStorage = require('../models/rdf_storage')
async = require 'async'
dbclient = require('americano-cozy').db.adapter.client

module.exports =

    executeSparql: (req, res, next) ->

        RDFStorage.store.execute req.body.query, (success, results) ->
            return next new Error(results) unless success

            toFetch = []
            for match in results
                for name, token of match
                    if token.token is 'uri' and 0 is token.value.indexOf 'https://my.cozy.io/'
                        id = token.value.replace('https://my.cozy.io/', '').split('.')[0]
                        toFetch.push id unless id in toFetch

            # fetch interesting docs
            docs = {}
            async.each toFetch, (id, cb) ->
                dbclient.get "data/#{id}/", (err, res, doc) ->
                    docs[doc._id] = doc
                    cb()

            , (err) ->
                res.send semantic: results, docs: docs

    executeNLP: (req, res, next) ->

        # SIMULATE QUESTION ASKED IS ALWAYS
        # Qui ai-je appelé en mars ?
        console.log "QUERY = '#{decodeURIComponent req.query.query }'"
        # sparql = parseNLP

        sparql = """
            PREFIX foaf: <http://xmlns.com/foaf/0.1/>
            PREFIX pcrd: <http://www.techtane.info/phonecommunicationlog.ttl#>
            PREFIX time: <http://www.w3.org/2006/time#>
            PREFIX  xsd: <http://www.w3.org/2001/XMLSchema#>
            SELECT ?result ?log ?begindtd
            WHERE {
                ?result <a> foaf:Person.
                ?result foaf:phone ?tel.
                ?log pcrd:hasCorrespondantNumber ?tel.
                ?log time:hasInstant ?begin.
                ?begin time:inDateTime ?begindtd.
                ?begindtd time:month 3 .
            }
        """

        module.exports.executeSparql body:query:sparql, res, next