# suppose RDFStorage has been inited before
RDFStorage = require '../models/rdf_storage'
# rdf = RDFStorage.store.rdf


module.exports.modelName = (model) ->
    "my:#{model._id or model}"

makeNode = (x) ->
     x

module.exports.makeTriple = makeTriple = (o, v, c) ->
    o = rdf.createNamedNode(o) if typeof o is "string"
    v = rdf.createNamedNode(v) if typeof v is "string"
    c = rdf.createNamedNode(c) if typeof c is "string"
    rdf.createTriple o, v, c

module.exports.newGraph = () -> rdf.createGraph()

module.exports.addDuration = (graph, model, units, count) ->
    name = module.exports.modelName model
    graph.add makeTriple name, "time:hasDuration", "#{name}.duration"
    graph.add makeTriple "#{name}.duration", "a", "time:DurationDescription"
    graph.add makeTriple "#{name}.duration", "time:#{units}", count

module.exports.addDatetime = (graph, model, date) ->
    name = module.exports.modelName model
    graph.add makeTriple name, "time:hasInstant", "#{name}.begin"
    graph.add makeTriple "#{name}.begin", "a", "time:Instant"
    graph.add makeTriple "#{name}.begin", "time:inDateTime", "#{name}.begindtd"
    graph.add makeTriple "#{name}.begindtd", "time:unitType", "time:unitSecond"
    graph.add makeTriple "#{name}.begindtd", "time:year", rdf.createLiteral date.getYear()
    graph.add makeTriple "#{name}.begindtd", "time:month", rdf.createLiteral date.getMonth()
    graph.add makeTriple "#{name}.begindtd", "time:day", rdf.createLiteral date.getDate()
    graph.add makeTriple "#{name}.begindtd", "time:hour", rdf.createLiteral date.getHours()
    graph.add makeTriple "#{name}.begindtd", "time:minute", rdf.createLiteral date.getMinutes()
    graph.add makeTriple "#{name}.begindtd", "time:second", rdf.createLiteral date.getSeconds()

module.exports.addPosition = (graph, mode, lat, long) ->
    name = module.exports.modelName model
    graph.add makeTriple name, "geo:location", "#{name}.location"
    graph.add makeTriple "#{name}.location", "a", "geo:Point"
    graph.add makeTriple "#{name}.location", "geo:lat", rdf.createLiteral lat
    graph.add makeTriple "#{name}.location", "geo:long", rdf.createLiteral long