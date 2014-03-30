# tokenizer = require './server/lib/tokenizer'
# abstracter = require './server/lib/abstracter'
# concretizer = require './server/lib/concretizer'
# sparqlbuilder = require './server/lib/sparqlbuilder'

# test = (code, nl) ->
#     console.log code, nl
#     tokenizer nl, (err, tokens) ->
#         console.log "EERORR = ", err
#         console.log code, "TOKENS = ", tokens
#         abstracter tokens, (err, abstracted) ->
#             console.log code, "ABSTRACTED = ", abstracted
#             console.log code, "CONCRETED = ", c = concretizer abstracted
#             console.log sparqlbuilder(c)

# #test '1.', "qui m'a appele en 2013"
# test '2.', "qui ai-je appele en mars"
#test '3.', "qui m'a vire 2000 euros"
#test '4.', "qui m'a appele la semaine derniere"
#test '5.', "mes courses de la semaine derniere"
#test '6.', "mes courses du mois dernier"






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



RDFStorage = require './server/models/rdf_storage'
RDFStorage.init ->
    store = RDFStorage.store

    sparql = """
            PREFIX foaf: <http://xmlns.com/foaf/0.1/>
            PREFIX prcd: <http://www.techtane.info/phonecommunicationlog.ttl#>
            PREFIX time: <http://www.w3.org/2006/time#>
            PREFIX  xsd: <http://www.w3.org/2001/XMLSchema#>
            PREFIX rcp: <http://www.techtane.info/receipt.ttl#>
            PREFIX pdta: <http://www.techtane.info/personaldata.ttl#>
            SELECT ?person ?log
            WHERE {
            ?person <a> foaf:Person .
            ?person foaf:phone ?tel .
            ?log <a> prcd:PhoneCommunicationLog .
            ?log prcd:hasCorrespondantNumber ?tel .
            ?log pdta:isOutbound true .
            ?log time:hasInstant/time:inDateTime/time:month 3 .
            }
        """
    store.execute sparql, (success, results) ->
          console.log results

    # store.graph (success, graph) ->
    #     count = 0
    #     graph.triples.forEach (t) ->
    #         if t.object.nominalValue is 'http://www.techtane.info/phonecommunicationlog.ttl#PhoneCommunicationLog'
    #             console.log t.predicate
    #             count++

    #     console.log "COUNT =", count