Tokenizer = require 'tokenizer'
module.exports = t = new Tokenizer((token, match) ->

  # change the type of the token before emitting it
  "phoneComLog" if match.type is "word" and token is "appel"
  "phoneComLog" if match.type is "word" and token is "appelé"
  "phoneComLog" if match.type is "word" and token is "appelée"

)
#template
#t.addRule /^$/,"rule"

# Maybe useful
t.addRule /^"[^"]*"$/, "citation"
# the 'maybe citation' rule is here to continue matching until
# the closing quote is found
t.addRule /^"[^"]*$/, "maybe citation"

# REFERENCES TO SELF
t.addRule /^ai-je\s$/i, "moi"
t.addRule /^m'a$/i, "moi"
t.addRule /^j'ai$/i, "moi"
t.addRule /^je$/i, "moi"

# Ponctuation

# REFERENCES TO OTHERS
t.addRule /^qui\s$/,"contact"


# PHONE COMMUNICATIONS

# TEMPORAL OBJECTS
## Years
t.addRule /^\d{4}$/,"year"
t.addRule /^en(\s)(\d{4})$/,"givenYear"
t.addRule /^cette(\s)année$/,"currentYear"
t.addRule /^l'année(\s)dernière$/,"lastYear"
## Months
## Days
## Specific date : le 17-03-1997
t.addRule /^(le(\s)\d{1,2})-(\d{1,2})-(\d{4})$/,"specificDate"

# if it's a word and it's not been matched yet it's probably a name
t.addRule /^\w+$/, "contact"
t.addRule /^(\s)+$/, "whitespace"
t.addRule /^[',;.:!?-]$/, "ponctuation"

unless module.parent
    #t.addRule /^salut$/i, "salut"
    t.on 'token', (tok) -> console.log tok
    t.write "qui ai-je appele en 2013"
    t.end()