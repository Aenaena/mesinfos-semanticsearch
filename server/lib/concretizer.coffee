timeIndicator = ['time:year', 'time:month', 'time:week']

pathToDate = (pdta) ->
    switch pdta
        when '?log' then 'time:hasInstant/time:inDateTime/'
        when '?receipt' then 'time:hasInstant/time:inDateTime/'
        when '?bankoperation' then 'time:hasInstant/time:inDateTime/'
        when '?vod' then 'time:hasInstant/time:inDateTime/'
            # ...
module.exports = (triples) ->

    if '?log' in triples.subjects
        # we want the instant
        triples.concrete.push
            s: '?log'
            o: '?instant'
            p: 'time:hasInstant/time:inDateTime'

        triples.subjects.push '?instant'

    if '?vod' in triples.subjects
        # we want the instant
        triples.concrete.push
            s: '?vod'
            o: '?instant'
            p: 'time:hasInstant/time:inDateTime'

        triples.subjects.push '?vod'

    if '?bankoperation' in triples.subjects
        # we want the instant
        triples.concrete.push
            s: '?bankoperation'
            o: '?instant'
            p: 'time:hasInstant/time:inDateTime'

        triples.subjects.push '?instant'

    if '?receipt' in triples.subjects
        # we want the instant
        triples.concrete.push
            s: '?receipt'
            o: '?instant'
            p: 'time:hasInstant/time:inDateTime'

        triples.subjects.push '?instant'


    if '?log' in triples.subjects and '?person' in triples.subjects
        t = s: '?person', o: '?tel', p: 'foaf:phone'
        c = s: '?log', o: '?tel', p: 'prcd:hasCorrespondantNumber'
        triples.concrete.push t
        triples.concrete.push c

    if '?log' in triples.subjects and '?point' in triples.subjects
        triples.concrete.push s: '?log', p: 'geo:location', o: '?point'

    for triple in triples.abstract
        if triple.p is 'pdta:isOutbound'
            triple.s = triples.pdta

        if triple.p in timeIndicator
            triple.s = triples.pdta
            triple.p = pathToDate(triples.pdta) + triple.p

        triples.concrete.push triple

    return triples.concrete
