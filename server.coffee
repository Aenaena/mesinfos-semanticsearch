americano = require 'americano'
init = require './server/initialize'

module.exports = start = (options, cb) ->
    options.name = 'cozy-files'
    options.port ?= 9119
    options.host ?= '127.0.0.1'
    americano.start options, (app, server) ->
        app.server = server

        require('./server/controllers/index').setApp app

        app.is_init = false
        console.log "server started"
        init (err) ->
            app.is_init = true
            console.log "init done"
            console.log err

        cb?(null, app, server)

if not module.parent
    start
        port: process.env.PORT
        host: process.env.HOST