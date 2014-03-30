SparqlClient = require 'sparql-client'
endpoint = 'http://dbpedia.org/sparql'

module.exports  = (query) ->
    client = new SparqlClient(endpoint)
    console.log "Query to " + endpoint
    console.log "Query: " + query
    client.query(query)
    # rest of the javascript on the github example
    #https://github.com/thomasfr/node-sparql-client
    #    .bind('city', '<http://dbpedia.org/resource/Vienna>')
    #.execute(function(error, results) {
    #process.stdout.write(util.inspect(arguments, null, 20, true)+"\n");
    #});