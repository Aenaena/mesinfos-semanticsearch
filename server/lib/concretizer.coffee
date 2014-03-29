timeIndicator = ['time:year', 'time:month']

pathToDate = (pdta) ->
    switch pdta
        when '?log' then 'time:hasInstant/time:inDateTime/'
            # ...
module.exports = (triples) ->

    for triple in triples.abstract
        if triple.p is 'pdta:isOutbound'
            triple.s = triples.pdta

        if triple.p in timeIndicator
            triple.s = triples.pdta
            triple.p = pathToDate(triples.pdta) + triple.p

        triples.concrete.push triple

    return triples.concrete
