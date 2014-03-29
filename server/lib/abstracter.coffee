module.exports = (tokens) ->

    concrete = []
    abstract = []
    pdta = null


    for i in [0..tokens.length-1]
        tok = tokens[i]

        switch tok.type
            when 'who'
                concrete.push s: '?person', p: 'a', o: 'foaf:Person'

            when 'when'
                concrete.push s: '?instant', p: 'a', o: 'time:Instant'

            when 'phoneComLog'
                pdta = '?log'
                concrete.push s: '?log', p: 'a', o: 'pcrd:PhoneCommunicationLog'

            when 'phoneCall'
                pdta = '?log'
                concrete.push s: '?log', p: 'a', o: 'pcrd:PhoneCommunicationLog'
                concrete.push s: '?log', p: 'pcrd:ComType', o: 'VOICE'

            when 'phoneText'
                pdta = '?log'
                concrete.push s: '?log', p: 'a', o: 'pcrd:PhoneCommunicationLog'
                concrete.push s: '?log', p: 'pcrd:ComType', o: 'SMS'

            when 'myself'
                abstract.push s: '?x', p: 'pdta:isOutbound', o:'true'

            when 'toSelf'
                abstract.push s: '?x', p: 'pdta:isOutbound', o:'false'

            when 'givenYear'
                abstract.push s: '?x', p: 'time:year', o: tok.content

            when 'month'
                abstract.push s: '?x', p: 'time:month', o: tok.content

    return {concrete, abstract, pdta}