index = require './index'
semantic = require './semantic'

module.exports =

    'progress': get: index.progress

    'images/:doctype/:id/:file': get: index.image

    'semantic/nlp': get: semantic.executeNLP
    'semantic/around': get: semantic.findAround
    'semantic/sparql': post: semantic.executeSparql


    'debug': get: (req, res, next) ->
        require('fs').createReadStream('./log/production.log').pipe res

    'reset': get: (req, res, next) ->
        RDFStorage = require '../models/rdf_storage'
        Progress = require '../models/progress_store'
        rimraf = require '../lib/rimraf'
        fs = require 'fs'
        
        cb = (err) ->
            console.log err
            next err

        rimraf './si', (err) ->
            return cb err if err
            rimraf './matcher', (err) ->
                return cb err if err
                fs.unlink 'search-index.json', (err) ->
                    return cb err if err
                    RDFStorage.requestDestroy 'all', (err) ->
                        return cb err if err
                        Progress.requestDestroy 'byDoctype', (err) ->
                            return cb err if err
                            res.send done: 'ok'
                            process.exit 1
