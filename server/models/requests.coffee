
defaultView = 'all': (doc) -> emit doc._id, {_id:doc._id, _rev:doc._rev}

module.exports =

    'bankoperation'         : defaultView
    'contact'               : defaultView
    'phonecommunicationlog' : defaultView
    'receipt'               : defaultView
    'receiptdetail'         : defaultView

    'rdf_storage'           : 'all': (doc) -> emit doc._id, doc
    'progress_store'        : 'byDoctype': (doc) -> emic doc.refdoctype, doc