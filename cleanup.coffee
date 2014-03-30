RDFStorage = require './server/models/rdf_storage'
Progress = require './server/models/progress_store'

RDFStorage.requestDestroy 'all', (err) ->
    console.log err if err
    Progress.requestDestroy 'byDoctype', (err) ->
        console.log err if err
        console.log "DONE"