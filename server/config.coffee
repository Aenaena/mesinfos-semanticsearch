americano = require 'americano'
config =
    common:
        use: [
            americano.static __dirname + '/../client/_public', maxAge: 86400000
            americano.bodyParser()
            (req, res, next) ->
                req.rawBody = ''
                req.setEncoding 'utf8'
                req.on 'data', (chunk) -> req.rawBody += chunk
                req.on 'end', -> next null
                req.on 'error', (err) -> next err

            americano.methodOverride()
            americano.errorHandler
                dumpExceptions: true
                showStack: true
        ]

    development: [
        americano.logger 'dev'
    ]

    production: [
        americano.logger 'short'
    ]

    plugins: [
        'americano-cozy'
    ]

module.exports = config