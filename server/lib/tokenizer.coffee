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

# PHONE COMMUNICATIONS
t.addRule /^appele$/,"phoneCall"
t.addRule /^appelee$/,"phoneCall"
t.addRule /^appel$/,"phoneCall"
t.addRule /^contacte$/,"phoneComLog"
t.addRule /^contactee$/,"phoneComLog"
t.addRule /^ecrit$/,"phoneText"

# TEMPORAL OBJECTS
## Temporal helpers
t.addRule /^ce$/, "currentTemporal"
t.addRule /^cette$/, "currentTemporal"

## Years
t.addRule /^\d{4}$/,"year"
t.addRule /^en(\d{4})$/,"givenYear"
t.addRule /^cette(\s)annee$/,"currentYear"
t.addRule /^l'annee(\s)derniere$/,"lastYear"
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
t.addRule /^semaine/, "week"
## Days
## Specific date : le 17-03-1997
t.addRule /^(le(\s)\d{1,2})-(\d{1,2})-(\d{4})$/,"specificDate"
## Quand
t.addRule /^quand$/, "when"

## BLACKLIST
t.addRule /^a$/, "blacklist"
t.addRule /^ai$/,"blacklist"
t.addRule /^en$/, "blacklist"

# if it's a word and it's not been matched yet it's probably a name
# wording for now
t.addRule /^\w+$/, "word"
t.addRule /^(\s)+$/, "whitespace"
t.ignore "whitespace"
t.ignore "blacklist"
t.ignore "ponctuation"
t.addRule /^[',;.:!?-]$/, "ponctuation"

unless module.parent
    t.on 'token', (tok) -> console.log tok
    #t.write "qui ai-je appele en 2013"
    #t.write "Quand Pierre m'a appele en juin"
    #t.write "Quand ai-je appele Pierre en juin"
    t.write "a qui ai-je ecrit cette semaine"
    t.end()
