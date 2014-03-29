RDFStorage = require './server/models/rdf_storage'
RDFStorage.init ->
    store = RDFStorage.store

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

    query = RDFStorage.store.engine.abstractQueryTree.parseQueryString(sparql)
    variables = query.units[0].projection.map (x) -> x.value.value
    console.log 'VARS = ', variables

    nodes = []
    edges = query.units[0].pattern.patterns[0].triplesContext.filter((triple) ->
        triple.subject.token is 'var' and triple.object.token is 'var'
    ).map (triple) ->
        nodes.push triple.subject.value unless triple.subject.value in nodes
        nodes.push triple.object.value unless triple.object.value in nodes
        s: triple.subject.value, o: triple.object.value

    linkedWith = (v) ->
        edges.map
            return e.o if e.s is v
            return e.s if e.o is v

    for node in nodes when node not in variables
        console.log "INTERNODE", node
        vars = linkedWith(node).filter (n) -> n in variables
        console.log "WITH VARS", vars

    # expand


    allOk = false
    while allOk

        allOk = true
        for edge in edges
            continue if edge.s in variables and edge.o in variables

            if edge.s in variables





    # simpleEdges = []


    # closest = (var, depth) ->

    #     edgesWith(var).each (edge) ->



    # for edge in edges
    #         simpleEdges.push edge

    #     else if edge.s in variables
    #         for edge in edgesWith e.o




    #     else if e.o in variables


    # simplify = (edges) ->
    #     newEdges = []



    # for edge in edges

    console.log 'EDGES = ', edges

# require('americano-cozy').db.adapter.client.headers

    # store.execute sparql, (success, results) ->

    #      console.log results

    # store.graph (success, graph) ->
    #     count = 0
    #     graph.triples.forEach (t) ->
    #         # if t.subject.nominalValue is 'https://my.cozy.io/3ae7f712245f210c3d171d7e4b07536b.begindtd'
    #         console.log t.subject.nominalValue

    #     console.log "COUNT =", count