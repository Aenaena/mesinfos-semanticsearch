async = require 'async'

 # utility function
 # get size models starting from limit
 # bypass DS _rev hiding
getBatch = (Model, skip, limit, callback) ->
    Model.rawRequest 'all',
        skip: skip
        limit: limit
        include_docs: true
    , (err, raws) ->
        callback err, raws?.map (raw) ->
            raw.doc._rev = raw.value._rev
            return raw.doc

# process all models of a given doctype by batch
# equivalent to Model.all + async.forEach operation, callback
# but only load [size] models in memory at once
module.exports.batch = (size, Model, operation, callback) ->

    currentIndex = 0
    nbOfResults = 0
    step = (cb) ->
        getBatch Model, currentIndex, size, (err, docs) ->
            return cb err if err
            nbOfResults = docs.length

            return cb null if docs.length is 0
            operation docs, (err) ->
                return cb err if err
                currentIndex += size
                cb null

    testdone = -> nbOfResults < size

    async.doUntil step, testdone, callback

