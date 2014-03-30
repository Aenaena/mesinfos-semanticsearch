path = require 'path'
async = require 'async'
fs = require 'fs'
rdfstore = require '../rdfstore'
americano = require 'americano-cozy'
ontologyFolder = path.join __dirname, '../../ontologies'
moment = require 'moment'
moment = new moment()
module.exports = RDFStorage = americano.getModel 'rdfstorage',
    'data': (x) -> x

RDFStorage.save = (data, callback) ->
    RDFStorage.request 'all', (err, docs) ->
        exist = docs?[0]
        if exist then exist.updateAttributes {data}, callback
        else RDFStorage.create {data}, callback

RDFStorage::asMockLocalStorage = ->
    data = @data
    getItem: (key) -> data[key]
    setItem: (key, value) -> data[key] = value
    removeItem: (key) -> delete data[key]

RDFStorage.init = (callback) ->
    RDFStorage.request 'all', (err, docs) ->
        return callback err if err
        RDFStorage.instance = docs?[0] or new RDFStorage data: {}
        storeMaker = rdfstore RDFStorage.instance.asMockLocalStorage()
        RDFStorage.store = storeMaker.create {persistent:true}, (store) ->
            store.setPrefix 'my', 'https://my.cozy.io/'
            store.setPrefix 'foaf', 'http://xmlns.com/foaf/0.1/'
            store.setPrefix 'pdta', 'http://www.techtane.info/personaldata.ttl#'
            store.setPrefix 'pcrd', 'http://www.techtane.info/phonecommunicationlog.ttl#'
            store.setPrefix 'time', 'http://www.w3.org/2006/time#'
            store.setPrefix 'geo', 'http://www.w3.org/2006/time#'
            store.setPrefix 'xsd', 'http://www.w3.org/2001/XMLSchema#'
            RDFStorage.loadOntologies store, (err) ->
                callback err, store

RDFStorage.loadOntologies = (store, callback) ->
    async.each fs.readdirSync(ontologyFolder), (ontologyfile, cb) ->
        turtle = fs.readFileSync path.join ontologyFolder, ontologyfile
        turtle = turtle.toString('utf8')
        store.load 'text/turtle', turtle, (success, results) ->
            cb if not success then new Error(results)
    , callback

RDFStorage.saveChanges = (callback) ->
    RDFStorage.save RDFStorage.instance.data, callback


RDFStorage.tools = tools =
    modelName: (model) ->
        "my:#{model._id or model}"

    makeGraph: ->
        rdf = RDFStorage.store.rdf
        rdf.createGraph()

    makeTriple: (o, v, c) ->
        rdf = RDFStorage.store.rdf
        o = rdf.createNamedNode(o) if typeof o is "string"
        v = rdf.createNamedNode(v) if typeof v is "string"
        c = rdf.createNamedNode(c) if typeof c is "string"
        rdf.createTriple o, v, c

    makeInt: (i) ->
        rdf = RDFStorage.store.rdf
        rdf.createLiteral i, null, rdf.resolve('xsd:integer')

    addDuration: (graph, model, units, count) ->
        name = tools.modelName model
        graph.add tools.makeTriple name, "time:hasDuration", "#{name}.duration"
        graph.add tools.makeTriple "#{name}.duration", "a", "time:DurationDescription"
        graph.add tools.makeTriple "#{name}.duration", "time:#{units}", tools.makeInt count

    addDatetime: (graph, model, date) ->
        name = tools.modelName model
        days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday', 'Saturday']

        formated = date.toISOString().substr(0, 19).replace(/:/g, '-')
        dtdname = 'my:instant/' + formated

        graph.add tools.makeTriple name, "time:hasInstant", "#{name}.begin"
        graph.add tools.makeTriple "#{name}.begin", "a", "time:Instant"
        graph.add tools.makeTriple "#{name}.begin", "time:inDateTime", dtdname
        graph.add tools.makeTriple dtdname, "a", "time:DateTimeDescription"
        graph.add tools.makeTriple dtdname, "time:unitType", "time:unitSecond"
        graph.add tools.makeTriple dtdname, "time:year", tools.makeInt date.getFullYear()
        graph.add tools.makeTriple dtdname, "time:month", tools.makeInt date.getMonth() + 1
        graph.add tools.makeTriple dtdname, "time:week", tools.makeInt moment.isoWeek(date)
        graph.add tools.makeTriple dtdname, "time:day", tools.makeInt date.getDate()
        graph.add tools.makeTriple dtdname, "time:dayOfWeek", 'time:' + days[date.getDay()]
        graph.add tools.makeTriple dtdname, "time:hour", tools.makeInt date.getHours()
        graph.add tools.makeTriple dtdname, "time:minute", tools.makeInt date.getMinutes()
        graph.add tools.makeTriple dtdname, "time:second", tools.makeInt date.getSeconds()

    addPosition: (graph, model, lat, long) ->
        name = tools.modelName model
        graph.add tools.makeTriple name, "geo:location", "#{name}.location"
        graph.add tools.makeTriple "#{name}.location", "a", "geo:Point"
        graph.add tools.makeTriple "#{name}.location", "geo:lat", tools.makeInt lat
        graph.add tools.makeTriple "#{name}.location", "geo:long", tools.makeInt long