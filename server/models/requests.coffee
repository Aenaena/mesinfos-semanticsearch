
defaultView = 'all': (doc) -> emit doc._id, {_id:doc._id, _rev:doc._rev}

module.exports =

    'contact'               : defaultView
    'bankoperation'         : defaultView
    'event'                 : defaultView
    'phonecommunicationlog' : defaultView
    'receipt'               : defaultView

    'link':
        'all': defaultView.all
        'bySubjectAndVerb': (doc) ->
            value = doc.object
            value = _id: value.substr 3 if value.substr(0,3) is 'id:'
            emit [doc.subject, doc.verb], value
        'bySubjectAndVerbDelSafe': (doc) ->
            emit [doc.subject, doc.verb], {_id:doc._id, _rev:doc._rev}
        'byObjectAndVerb': (doc) ->
            value = doc.subject
            value = _id: value.substr 3 if value.substr(0,3) is 'id:'
            emit [doc.object, doc.verb], value
        'byObjectAndVerbDelSafe': (doc) ->
            emit [doc.subject, doc.verb], {_id:doc._id, _rev:doc._rev}