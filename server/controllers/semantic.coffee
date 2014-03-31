RDFStorage = require('../models/rdf_storage')
async = require 'async'
dbclient = require('americano-cozy').db.adapter.client
tokenizer = require '../lib/tokenizer'
abstracter = require '../lib/abstracter'
concretizer = require '../lib/concretizer'
sparqlbuilder = require '../lib/sparqlbuilder'


module.exports =


    findAround: (req, res, next) ->
        dbclient.get "data/#{req.query.id}/", (err, response, doc) ->
            Model = try require '../models/' + doc.docType.toLowerCase()
            catch err then false

            if sparql = Model?.prototype?.aroundSPARQL?.apply doc
                module.exports.executeSparql rawBody:sparql, res, next
            else
                res.send semantic:[]


    executeSparql: (req, res, next) ->

        sparql = req.rawBody

        console.log sparql

        try query = RDFStorage.store.engine.abstractQueryTree.parseQueryString(sparql)
        catch err then return next err
        variables = query.units[0].projection.map (x) -> x.value.value
        console.log 'VARS = ', variables

        nodes = []
        links = []
        #IHAVENOIDEAWHATIAMDOING
        edges = query.units[0].pattern.patterns[0].triplesContext or
        query.units[0].pattern.patterns[0].value.reduce (prev, block) ->
            prev.concat block.patterns[0].triplesContext
        , []

        edges = edges.filter (triple) ->
            triple.subject.token is 'var' and triple.object.token is 'var'

        edges = edges.map (triple) ->
            nodes.push triple.subject.value unless triple.subject.value in nodes
            nodes.push triple.object.value unless triple.object.value in nodes
            s: triple.subject.value, o: triple.object.value

        links = links.concat edges

        linkedWith = (v) -> edges.map (e) ->
            return e.o if e.s is v
            return e.s if e.o is v

        for node in nodes when node not in variables
            vars = linkedWith(node).filter (n) -> n in variables
            if vars.length is 2
                links.push s: vars[0], o: vars[1]
            else if vars.length is 3
                links.push
                    s: vars[0], o: vars[1]
                    s: vars[1], o: vars[2]
                    s: vars[0], o: vars[2]

        handleResults = (success, results) ->
            return next new Error(results) unless success

            console.log "HANDLING RESULTS", results

            toFetch = []
            for match in results
                for name, token of match when token
                    if token.token is 'uri' and 0 is token.value.indexOf 'https://my.cozy.io/'
                        id = token.value.replace('https://my.cozy.io/', '').split('.')[0]
                        continue if id.indexOf('/') isnt -1 # instant/ & location/
                        toFetch.push id unless id in toFetch

            console.log "TO FETCH", toFetch

            # fetch interesting docs
            docs = {}
            async.each toFetch, (id, cb) ->
                dbclient.get "data/#{id}/", (err, res, doc) ->
                    docs[doc._id] = doc
                    cb()

            , (err) ->
                console.log "RESULT = ", results.length
                res.send links: links, semantic: results, docs: docs

        try RDFStorage.store.execute sparql, handleResults
        catch err then next err

    executeNLP: (req, res, next) ->

        # SIMULATE QUESTION ASKED IS ALWAYS
        # Qui ai-je appelé en mars ?
        console.log "QUERY = '#{decodeURIComponent req.query.query }'"
        nl = decodeURIComponent req.query.query
        nl = nl.toLowerCase()
        tokenizer nl, (err, tokens) ->
            return next err if err
            console.log "TOKENS = ", tokens
            abstracter tokens, (err, abstracted) ->
                return next err if err
                console.log "ABSTRACTED = ", abstracted
                console.log "CONCRETED = ", concretizer abstracted
                sparql = sparqlbuilder abstracted
                module.exports.executeSparql rawBody:sparql, res, next
