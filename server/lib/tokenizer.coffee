Tokenizer = require 'tokenizer'
module.exports = t = new Tokenizer((token, match) ->

  # change the type of the token before emitting it
  "phoneComLog" if match.type is "word" and token is "appel"
  "phoneComLog" if match.type is "word" and token is "appele"
  "phoneComLog" if match.type is "word" and token is "appelee"

)
#template
#t.addRule /^$/,"rule"

# Maybe useful
t.addRule /^"[^"]*"$/, "citation"
# the 'maybe citation' rule is here to continue matching until
# the closing quote is found
t.addRule /^"[^"]*$/, "maybe citation"

# REFERENCES TO SELF
t.addRule /^je$/i, "moi"
t.addRule /^m'a$/i, "moi"
t.addRule /^j'ai$/i, "moi"
t.addRule /^je$/i, "moi"

# Ponctuation

# REFERENCES TO OTHERS
t.addRule /^qui$/i,"contact"


# PHONE COMMUNICATIONS
t.addRule /^appele$/,"phoneComLog"
t.addRule /^appelee$/,"phoneComLog"
t.addRule /^appel$/,"phoneComLog"



# TEMPORAL OBJECTS
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


## Days
## Specific date : le 17-03-1997
t.addRule /^(le(\s)\d{1,2})-(\d{1,2})-(\d{4})$/,"specificDate"

## BLACKLIST
t.addRule /^ai$/,"blacklist"


# if it's a word and it's not been matched yet it's probably a name
# wording for now
t.addRule /^\w+$/, "word"
t.addRule /^(\s)+$/, "whitespace"
t.ignore "whitespace"
t.addRule /^[',;.:!?-]$/, "ponctuation"

unless module.parent
    #t.addRule /^salut$/i, "salut"
    t.on 'token', (tok) -> console.log tok
    #t.write "qui ai-je appele en 2013"
    t.write "qui a appele Romain en juin 2014"
    t.end()
