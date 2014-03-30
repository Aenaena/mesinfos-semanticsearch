moment = require 'moment'
async = require 'async'
moment = new moment()
moment.lang('fr')
valuechecker = require './valuechecker'

module.exports = (tokens, callback) ->

    concrete = []
    abstract = []
    ops = []
    pdta = null


    for i in [0..tokens.length-1]
        tok = tokens[i]

        switch tok.type
            when 'who'
                concrete.push s: '?person', p: '<a>', o: 'foaf:Person'

            when 'when'
                concrete.push s: '?instant', p: '<a>', o: 'time:Instant'

            when 'phoneComLog'
                pdta = '?log'
                concrete.push s: '?log', p: '<a>/rdfs:subClassOf', o: 'prcd:PhoneCommunicationLog'

            when 'phoneCall'
                pdta = '?log'
                concrete.push s: '?log', p: '<a>', o: 'prcd:PhoneCall'
                #concrete.push s: '?log', p: 'prcd:ComType', o: 'VOICE'

            when 'phoneText'
                pdta = '?log'
                concrete.push s: '?log', p: '<a>', o: 'prcd:TextMessage'

            when 'myself'
                abstract.push s: '?x', p: 'pdta:isOutbound', o:'true'

            when 'toSelf'
                abstract.push s: '?x', p: 'pdta:isOutbound', o:'false'

            when 'givenYear'
                abstract.push s: '?x', p: 'time:year', o: tok.content

            when 'givenMonth'
                tok.content = 'août' if tok.content is 'aout'
                abstract.push s: '?x', p: 'time:month', o: moment.month(tok.content).format('M')

            when 'allArticles'
                pdta = '?receipt'
                concrete.push s: '?receipt', p: '<a>', o: 'rcp:Receipt'

            when 'article'
                concrete.push s: '?receipt', p: '<a>', o: 'rcpd:ReceiptDetail'

            when 'bankTransfer'
                pdta = '?bankoperation'
                concrete.push s: '?bankoperation', p: '<a>', o: 'bko:BankOperation'

            when 'inbound'
                previous = tokens[i-1].type
                if previous == 'bankTransfer'
                    concrete.push s: '?bankoperation', p: 'pdta:isOutbound', o: 'false'
                else
                    abstract.push s: '?x', p: 'pdta:isOutbound', o: 'false'

            when 'outbound'
                previous = tokens[i-1].type
                if previous == 'bankTransfer'
                    concrete.push s: '?bankoperation', p: 'pdta:isOutbound', o: 'true'
                else
                    abstract.push s: '?x', p: 'pdta:isOutbound', o: 'false'

            when 'float'
                # Check if it's a price
                next = tokens[i+1].type
                if next == 'priceMarker'
                    abstract.push s: '?x', p: 'xsd:float', o: tok.content
                #TODO Otherwise it's maybe a duration

            when 'currentTemporal'
                next = tokens[i+1].type
                # Check if it's this week
                if next == 'week'
                    abstract.push s: '?x', p: 'time:week', o: moment.isoWeek()
                # Or month
                else if next == 'month'
                    abstract.push s: '?x', p: 'time:month', o: moment.month()
                # Or year
                else if next == 'year'
                    abstract.push s: '?x', p: 'time:year', o: moment.year()

            when 'lastTemporal'
                previous = tokens[i-1].type
                # Check if it's last week
                if previous == 'week'
                    abstract.push s: '?x', p: 'time:week', o: moment.subtract('weeks', 1).isoWeek()
                # Or last month
                else if previous == 'month'
                    abstract.push s: '?x', p: 'time:month', o: moment.subtract('months', 1).month()
                # Or last year
                else if previous == 'year'
                    abstract.push s: '?x', p: 'time:year', o: moment.subtract('years', 1).year()

            when 'specificDate'
                abstract.push s: '?x', p: 'time:date', o: moment.format('YYYY-MM-DD')

            when 'wordToEvaluate'
                do (tok) -> ops.push (cb) -> valuechecker tok, cb

            when 'video'
                pdta = '?vod'
                concrete.push s: '?vod', o: '<a>', p: 'vod:VideoOnDemand'


    async.parallel ops, (err, filters) ->
        filters = filters.map((f) -> "FILTER(#{f})").join("\n")
        callback null, {concrete, abstract, pdta, filters}
