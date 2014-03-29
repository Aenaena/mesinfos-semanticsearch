app = null

module.exports.setApp = (ref) -> app = ref

module.exports.progress = (req, res, next) ->
    res.send started: app.init_status

module.exports.image = (req, res, next) ->
    {doctype, id, file} = req.params
    Model = require "../models/#{req.params.doctype}"
    Model.find id, (err, model) ->
        return next err if err

        if model._attachments?[file]
            stream = model.getFile file, (err) ->
                return res.error 500, "File fetching failed.", err if err

            stream.pipe res
        else
            next new Error('no such attachment')