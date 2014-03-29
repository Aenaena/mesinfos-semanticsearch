module.exports = (tokens) ->

    out = []

    for tok in tokens
        switch tok.type
            when 'who'
                out.push s: '?x', p: 'a', o: 'foaf:Person' 
            when 'when'
                out.push s: '?x', p: 'a', o: 'time:Instant'
            
            when 'year'
                out.push s: '?x', p: 'a', o: 'time:Instant'
            # Other time stuff
            # References to self

            when 'wordToEvaluate'
                # call value checker
                # value = ?
                # complex = {}
                # complex[class] = 
                # complex[property] = 
                # out.push complex

            #when 'appele'
                #complex = []
                #complex.push s: '', p: '', o: 'prcd:PhoneCommunicationLog'
                #out.push complex
        
                # ...
            
