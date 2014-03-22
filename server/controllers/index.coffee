app = null

module.exports.setApp = (ref) -> app = ref

module.exports.started = (req, res, next) ->
    res.send started: app.init_status