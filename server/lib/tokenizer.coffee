rules = (t) ->
    #template
    #t.addRule /^$/,"rule"

    # Maybe useful
    #t.addRule /^"[^"]*"$/, "citation"
    # the 'maybe citation' rule is here to continue matching until
    # the closing quote is found
    #t.addRule /^"[^"]*$/, "maybe citation"

    # REFERENCES TO SELF AND POSSESSIONS
    t.addRule /^je$/i, "myself"
    t.addRule /^m'a$/i, "toSelf"
    t.addRule /^j'ai$/i, "myself"
    t.addRule /^je$/i, "myself"
    t.addRule /^mes$/, "my"

    # Ponctuation

    # REFERENCES TO OTHERS
    t.addRule /^qui$/i,"who"
    t.addRule /^avec$/i,"with"


    # QUANTITIES
    t.addRule /^combien$/i,"howMany"
    t.addRule /^plus$/i,"biggerThan"

    # ACTIONS
    t.addRule /^passe$/, "did"
    t.addRule /^fait$/, "did"

    # PHONE COMMUNICATIONS
    t.addRule /^appele$/,"phoneCall"
    t.addRule /^appelee$/,"phoneCall"
    t.addRule /^appel$/,"phoneCall"
    t.addRule /^appels$/,"phoneCall"
    t.addRule /^contacte$/,"phoneComLog"
    t.addRule /^contactee$/,"phoneComLog"
    t.addRule /^sms$/, "phoneText"
    t.addRule /^ecrit$/,"phoneText"

    # TEMPORAL OBJECTS
    ## Temporal helpers
    t.addRule /^cette annee$/, "currentTemporal"
    t.addRule /^ce$/, "currentTemporal"
    t.addRule /^cette$/, "currentTemporal"
    t.addRule /^dernier$/, "lastTemporal"
    t.addRule /^derniere$/, "lastTemporal"

    ## Years
    t.addRule /^\d{4}$/,"givenYear"
    t.addRule /^en(\d{4})$/,"givenYear"
    t.addRule /^annee$/,"year"
    ## Months
    t.addRule /^mois$/, "month"
    t.addRule /^mois-ci$/, "month"
    t.addRule /^janvier$/,"givenMonth"
    t.addRule /^fevrier$/,"givenMonth"
    t.addRule /^mars$/,"givenMonth"
    t.addRule /^avril/,"givenMonth"
    t.addRule /^mai$/,"givenMonth"
    t.addRule /^juin$/,"givenMonth"
    t.addRule /^juillet$/,"givenMonth"
    t.addRule /^aout$/,"givenMonth"
    t.addRule /^septembre$/,"givenMonth"
    t.addRule /^octobre$/,"givenMonth"
    t.addRule /^novembre$/,"givenMonth"
    t.addRule /^decembre$/,"givenMonth"
    ## Weeks
    t.addRule /^semaine$/, "week"
    ## Days
    ## Minute
    # TODO check if duration in abstracter.
    t.addRule /^minute$/, "minutes"
    t.addRule /^minutes$/, "minutes"

    ## Specific date : le 17-03-1997
    t.addRule /^(le(\s)\d{1,2})-(\d{1,2})-(\d{4})$/,"specificDate"
    ## Quand
    t.addRule /^quand$/, "when"

    # BANK DETAILS
    t.addRule /^virement$/, "bankTransfer"
    t.addRule /^virements$/, "bankTransfer"
    t.addRule /^recus$/, "inbound"
    t.addRule /^recu$/, "inbound"
    t.addRule /^envoye$/, "outbound"
    t.addRule /^envoyes$/, "outbound"

    # RECEIPTS
    t.addRule /^courses$/, "allArticles"
    t.addRule /^article$/, "article"
    # Prix
    t.addRule /^euros$/, "priceMarker"
    t.addRule /^euro$/, "priceMarker"
    # Floats
    t.addRule /^(?:[1-9]\d*|0)+(?:\.\d+)?$/, "float"

    # VOD : we treat everything as a video, be it a movie, tv show etc
    t.addRule /^film$/, "video"
    t.addRule /^films$/, "video"
    t.addRule /^serie$/, "video"
    t.addRule /^series$/, "video"
    t.addRule /^video$/, "video"
    t.addRule /^videos$/, "video"
    t.addRule /^VOD$/, "video"
    t.addRule /^telefilm$/, "video"

    ## VOD actions

    t.addRule /^regarde$/, "watched"
    t.addRule /^regardes$/, "watched"
    t.addRule /^regardee$/, "watched"
    t.addRule /^regardees$/, "watched"
    t.addRule /^vu$/, "watched"
    t.addRule /^vus$/, "watched"
    t.addRule /^vue$/, "watched"
    t.addRule /^vues$/, "watched"



    ## BLACKLIST
    t.addRule /^a$/, "blacklist"
    t.addRule /^ai$/,"blacklist"
    t.addRule /^en$/, "blacklist"
    t.addRule /^d$/, "blacklist"
    t.addRule /^de$/, "blacklist"
    t.addRule /^la$/, "blacklist"


    # if it's a word and it's not been matched yet it's probably a name
    # wording for now
    t.addRule /^\w+$/, "wordToEvaluate"
    t.addRule /^(\s)+$/, "whitespace"


    t.ignore "whitespace"
    t.ignore "blacklist"
    t.ignore "ponctuation"
    t.addRule /^[',;.:!?-]$/, "ponctuation"


disect = require('disect')

module.exports = (input, callback) ->
    index = 0
    step = 64
    _regexes = []
    _ignored = {}
    tokens = []

    addRule = (regex, type) -> _regexes.push regex: regex, type: type
    ignore = (type) -> _ignored[type] = true

    rules {addRule, ignore}

    Token = (content, type) ->
        this.content = content
        this.type = type

    _getMatchingRule = (str) ->
        for regex in _regexes when regex.regex.test str
            return regex
        return null

    _tokenize = (data) ->
        maxIndex = disect 0, data.length, (index) ->
            buf = data.substring(0, index + 1)
            return _getMatchingRule(buf) is null

        str = data.substring(0, maxIndex);
        rule = _getMatchingRule(str);

        tokens.push new Token(str, rule.type) unless _ignored[rule.type]

        if maxIndex is data.length
            return
        else
            _tokenize data.substring maxIndex

    _tokenize(input)
    callback null, tokens
