# moment = require 'moment'
# moment = moment()
# moment.month('august').format('M')


tokenizer = require './server/lib/tokenizer'
abstracter = require './server/lib/abstracter'
concretizer = require './server/lib/concretizer'
sparqlbuilder = require './server/lib/sparqlbuilder'

test = (code, nl) ->
    console.log code, nl
    tokenizer nl, (err, tokens) ->
        console.log "EERORR = ", err
        console.log code, "TOKENS = ", tokens
        abstracter tokens, (err, abstracted) ->
            console.log code, "ABSTRACTED = ", abstracted
            console.log code, "CONCRETED = ", c = concretizer abstracted
            console.log sparqlbuilder(c)

#test '1.', "qui m'a appele en 2013"
#test '2.', "qui ai-je appele en mars"
#test '3.', "qui m'a vire 2000 euros"
#test '4.', "qui m'a appele la semaine derniere"
#test '5.', "mes courses de la semaine derniere"
#test '6.', "mes courses du mois dernier"
test '7.', "virements recus de Pierre en juin"







    # #t.write
    # #t.write "quand Pierre m'a appele en juin"
    # #t.write "quand ai-je appele Pierre en juin"
    # #t.write "a qui ai-je ecrit cette semaine"
    # #t.write "a qui ai-je ecrit l'annee derniere ?"
    # #t.write "qui m'a appele en 2013"
    # #t.write "qui m'a ecrit cette annee"
    # #t.write "mes courses de plus de cent euros"
    # t.write "combien d'appels de plus de dix minutes ai je passe cette semaine avec Pierre"
    # t.end()



# RDFStorage = require './server/models/rdf_storage'
# RDFStorage.init ->
#     store = RDFStorage.store

#     sparql = """
#             PREFIX foaf: <http://xmlns.com/foaf/0.1/>
#             PREFIX pcrd: <http://www.techtane.info/phonecommunicationlog.ttl#>
#             PREFIX time: <http://www.w3.org/2006/time#>
#             PREFIX  xsd: <http://www.w3.org/2001/XMLSchema#>
#             SELECT ?result ?log ?begindtd
#             WHERE {
#                 ?result <a> foaf:Person.
#                 ?result foaf:phone ?tel.
#                 ?log pcrd:hasCorrespondantNumber ?tel.
#                 ?log time:hasInstant ?begin.
#                 ?begin time:inDateTime ?begindtd.
#                 ?begindtd time:month 3 .
#             }
#         """

#     query = RDFStorage.store.engine.abstractQueryTree.parseQueryString(sparql)
#     variables = query.units[0].projection.map (x) -> x.value.value
#     console.log 'VARS = ', variables

#     nodes = []
#     edges = query.units[0].pattern.patterns[0].triplesContext.filter((triple) ->
#         triple.subject.token is 'var' and triple.object.token is 'var'
#     ).map (triple) ->
#         nodes.push triple.subject.value unless triple.subject.value in nodes
#         nodes.push triple.object.value unless triple.object.value in nodes
#         s: triple.subject.value, o: triple.object.value

#     linkedWith = (v) ->
#         edges.map
#             return e.o if e.s is v
#             return e.s if e.o is v

#     for node in nodes when node not in variables
#         console.log "INTERNODE", node
#         vars = linkedWith(node).filter (n) -> n in variables
#         console.log "WITH VARS", vars



#     # expand


#     allOk = false
#     while allOk

#         allOk = true
#         for edge in edges
#             continue if edge.s in variables and edge.o in variables

#             if edge.s in variables





#     # simpleEdges = []


#     # closest = (var, depth) ->

#     #     edgesWith(var).each (edge) ->



#     # for edge in edges
#     #         simpleEdges.push edge

#     #     else if edge.s in variables
#     #         for edge in edgesWith e.o




#     #     else if e.o in variables


#     # simplify = (edges) ->
#     #     newEdges = []



#     # for edge in edges

#     console.log 'EDGES = ', edges

# # require('americano-cozy').db.adapter.client.headers

#     # store.execute sparql, (success, results) ->

#     #      console.log results

#     # store.graph (success, graph) ->
#     #     count = 0
#     #     graph.triples.forEach (t) ->
#     #         # if t.subject.nominalValue is 'https://my.cozy.io/3ae7f712245f210c3d171d7e4b07536b.begindtd'
#     #         console.log t.subject.nominalValue

#     #     console.log "COUNT =", count