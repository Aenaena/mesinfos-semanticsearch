americano = require 'americano-cozy'
async = require 'async'

module.exports = Link = americano.getModel 'SemanticLink',
    subject       : String
    verb          : String
    object        : String

Models =
    'contact': require './contact'


# PRIVATE HELPERS FUNCTIONS
normalizeModel = (model) ->
    if typeof model is 'string' then model
    else "id:#{model.id}"

makeOptions = (model, verb) ->
    model = normalizeModel model
    return if verb then key: [model, verb]
    else
        startkey: [model]
        endkey: [model, "\u9999"]


handleResults = (results, callback) ->
    results = results.map (raw) ->

        doctype = raw.doc?.docType?.toLowerCase()
        doc = if klass = Models[doctype] then klass(raw.doc)
        else raw.doc

        concept: doc
        verb: raw.key[1]

    #@ TODO apply correct jugglingDB Model to the raw object
    callback null, results

# create a link
# someModel can be the model itself or a string value
# usage Link.make someModel, 'is-a', otherModel, (err) ->
Link.make = (subject, verb, object, callback) ->
    data =
        subject: normalizeModel subject
        verb: verb
        object: normalizeModel object

    Link.create data, callback

# get all links pointing from a model
# usage Link.getFrom someModel, ['is-a',] (err, results) ->
Link.getFrom = (subject, verb=null, callback) ->
    [verb, callback] = [null, verb] if typeof verb is 'function'

    options = makeOptions subject, verb
    options.include_docs = true

    Link.rawRequest 'bySubjectAndVerb', options, (err, results) ->
        handleResults results, callback

# get all links pointing to a model
# usage Link.getTo someModel, ['is-a',] (err, results) ->
Link.getTo = (object, verb=null, callback) ->
    [verb, callback] = [null, verb] if typeof verb is 'function'

    options = makeOptions object, verb
    options.include_docs = true

    Link.rawRequest 'byObjectAndVerb', options, (err, results) ->
        handleResults results, callback

# delete all links from and to a model
Link.clean = (model, callback) ->
    options = makeOptions model, null

    async.series [
        (cb) -> Link.requestDestroy 'bySubjectAndVerbDelSafe', options, cb
        (cb) -> Link.requestDestroy 'byObjectAndVerbDelSafe', options, cb
    ], callback