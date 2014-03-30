findsubjects = require './findsubjects'
timeIndicator = ['time:year', 'time:month', 'time:week']

pathToDate = (pdta) ->
    switch pdta
        when '?log' then 'time:hasInstant/time:inDateTime/'
        when '?receipt' then 'time:hasInstant/time:inDateTime/'
        when '?bankoperation' then 'time:hasInstant/time:inDateTime/'
            # ...
module.exports = (triples) ->

    subjects = findsubjects(triples.concrete)
    console.log "HELLO", subjects
    if '?log' in subjects and '?person' in subjects
        t = s: '?person', o: '?tel', p: 'foaf:phone'
        c = s: '?log', o: '?tel', p: 'prcd:hasCorrespondantNumber'
        triples.concrete.push t
        triples.concrete.push c

    for triple in triples.abstract
        if triple.p is 'pdta:isOutbound'
            triple.s = triples.pdta

        if triple.p in timeIndicator
            triple.s = triples.pdta
            triple.p = pathToDate(triples.pdta) + triple.p

        triples.concrete.push triple

    return triples.concrete
