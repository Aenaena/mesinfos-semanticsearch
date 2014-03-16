# assert = require 'assert'

# rdfstore = require '../server/rdfstore'
# process.on 'uncaughtException', (e) -> console.log e.stack

# describe "test rdfstore works as described on its README.md", ->

#     it "create", (done) ->

#         rdfstore.create (store) ->
#             store.execute 'LOAD <http://dbpedia.org/resource/Tim_Berners-Lee> INTO GRAPH <http://example.org/people>', ->

#               store.setPrefix 'dbp', 'http://dbpedia.org/resource/'

#               store.node store.rdf.resolve('dbp:Tim_Berners-Lee'), "http://example.org/people", (success, graph) ->

#                 peopleGraph = graph.filter store.rdf.filters.type store.rdf.resolve "foaf:Person"

#                 query = """
#                     PREFIX rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\
#                                PREFIX foaf: <http://xmlns.com/foaf/0.1/>\
#                                PREFIX : <http://example.org/>\
#                                SELECT ?s FROM NAMED :people { GRAPH ?g { ?s rdf:type foaf:Person } }
#                 """
#                 store.execute query, (success, results) ->
#                     assert(peopleGraph.toArray()[0].subject.valueOf() is results[0].s.value, "SPARQL BITCH !")
#                     done()