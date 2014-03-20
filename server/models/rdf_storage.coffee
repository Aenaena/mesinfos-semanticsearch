path = require 'path'
async = require 'async'
fs = require 'fs'
rdfstore = require '../rdfstore'
americano = require 'americano-cozy'
ontologyFolder = path.join __dirname, '../../ontologies'

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

RDFStorage.init = (callback) ->
    RDFStorage.request 'all', (err, docs) ->
        return callback err if err
        RDFStorage.instance = docs?[0]? or new RDFStorage data: {}
        console.log "HERE"
        storeMaker = rdfstore RDFStorage.instance.asMockLocalStorage()
        RDFStorage.store = storeMaker.create {persistent:true}, (store) ->
            store.setPrefix 'my', 'https://my.cozy.io/'
            store.setPrefix 'foaf', 'http://xmlns.com/foaf/0.1/'
            store.setPrefix 'pdta', 'http://www.techtane.info/personaldata.ttl#'
            store.setPrefix 'pcrd', 'http://www.techtane.info/phonecommunicationlog.ttl#'
            store.setPrefix 'time', 'http://www.w3.org/2006/time#'
            store.setPrefix 'geo', 'http://www.w3.org/2006/time#'
            async.each fs.readdirSync(ontologyFolder), (ontologyfile, cb) ->
                turtle = fs.readFileSync path.join ontologyFolder, ontologyfile
                store.load 'text/turtle', turtle.toString('utf8'), (success, results) ->
                    cb unless success then new Error(results)
            , (err) -> callback err, store

RDFStorage.saveChanges = (callback) ->
    RDFStorage.save RDFStorage.instance.data, callback
