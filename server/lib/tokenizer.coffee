Tokenizer = require 'tokenizer'
module.exports = t = new Tokenizer((token, match) ->

)
#template
#t.addRule /^$/,"rule"

# Maybe useful
t.addRule /^"[^"]*"$/, "citation"
# the 'maybe citation' rule is here to continue matching until
# the closing quote is found
t.addRule /^"[^"]*$/, "maybe citation"

# REFERENCES TO SELF
t.addRule /^je$/i, "mySelf"
t.addRule /^m'a$/i, "toSelf"
t.addRule /^j'ai$/i, "myself"
t.addRule /^je$/i, "myself"

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
t.addRule /^ecrit$/,"phoneText"

# RECEIPTS
t.addRule /^courses$/, "allArticles"
t.addRule /^article$/, "article"
# Prix
t.addRule /^euros$/, "priceMarker"
t.addRule /^euro$/, "priceMarker"


# TEMPORAL OBJECTS
## Temporal helpers
t.addRule /^ce$/, "currentTemporal"
t.addRule /^cette$/, "currentTemporal"
t.addRule /^derniere$/, "lastTemporal"

## Years
t.addRule /^\d{4}$/,"givenYear"
t.addRule /^en(\d{4})$/,"givenYear"
t.addRule /^annee$/,"year"
## Months
t.addRule /^janvier$/,"month"
t.addRule /^fevrier$/,"month"
t.addRule /^mars$/,"month"
t.addRule /^avril/,"month"
t.addRule /^mai$/,"month"
t.addRule /^juin$/,"month"
t.addRule /^juillet$/,"month"
t.addRule /^aout$/,"month"
t.addRule /^septembre$/,"month"
t.addRule /^octobre$/,"month"
t.addRule /^novembre$/,"month"
t.addRule /^decembre$/,"month"
## Weeks
t.addRule /^semaine$/, "week"
## Days
## Minute
t.addRule /^minute$/, "minutes"
t.addRule /^minutes$/, "minutes"

## Specific date : le 17-03-1997
t.addRule /^(le(\s)\d{1,2})-(\d{1,2})-(\d{4})$/,"specificDate"
## Quand
t.addRule /^quand$/, "when"

## BLACKLIST
t.addRule /^a$/, "blacklist"
t.addRule /^ai$/,"blacklist"
t.addRule /^en$/, "blacklist"
t.addRule /^d$/, "blacklist"
t.addRule /^de$/, "blacklist"

# if it's a word and it's not been matched yet it's probably a name
# wording for now
t.addRule /^\w+$/, "wordToEvaluate"
t.addRule /^(\s)+$/, "whitespace"
t.ignore "whitespace"
t.ignore "blacklist"
t.ignore "ponctuation"
t.addRule /^[',;.:!?-]$/, "ponctuation"

unless module.parent
    t.on 'token', (tok) -> console.log tok
    #t.write "qui ai-je appele en 2013"
    #t.write "quand Pierre m'a appele en juin"
    #t.write "quand ai-je appele Pierre en juin"
    #t.write "a qui ai-je ecrit cette semaine"
    #t.write "a qui ai-je ecrit l'annee derniere ?"
    #t.write "qui m'a appele en 2013"
    #t.write "qui m'a ecrit cette annee"
    #t.write "mes courses de plus de cent euros"
    t.write "combien d'appels de plus de dix minutes ai je passe cette semaine avec Pierre"
    t.end()
