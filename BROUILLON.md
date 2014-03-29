LES REQUETES DOIVENT ETRE A LA VOIX ACTIVE.

Quand ai-je acheté du vin ?

Quel vin ai-je acheté que j'ai achete mardi ?

Quand ai-je recu de l'argent de Pierre ?
                 le virement

Quand le virement de pierre est-il arrive

Les virements (recu) de Mutuelle Générale (en Mars | en 2013)

Mes courses de plus de 100 euros


Quand -> X a time:Instant
Les Virement -> X a BankOperation
L

X a Y




Quand ai-je appelé Pierre ?            ---> [QUAND] [MOI] [APPEL] [PIERRE]
Quand pierre m'a appelé (en juin) ?    ---> [QUAND] [PIERRE] [APPEL] [MOI] [DATECONSTRAINT:juin] -->
Qui ai-je appelé en juin ?
---> [QUI] [MYSELF] [APPEL] [givenMonth:juin]
-->
    ?person a person
    ? pdta:isOutbound true
    X a phonelog
    Z time:month Juin



--> +
    X /time:hasInstant/time:beginInDTD Z


--> [X a person] [Y a phonecomlog] [X ]

Qui ai-je contacté en juin ?

# THINKING META
Décortiquer des requetes va nous permettre de comprendre comment générer automatiquement du SPARQL qui répond a nos questions.

# SOME EASY QUERY...
Qui m'a appelé en 2013 ?
STEP 1 TOKENIZE [WHO] [TOSELF] [PHONECALL] [GIVENYEAR]
STEP 2 VALUECHECKER # Just needed for "ME" here but this is a straightforward,easy mapping done at tokenization level.
STEP 3 ABSTRACT SEMANTIC REPRESENTATION
A Foaf:Person
A prcd:PhoneCommunicationLog
A Foaf:Person of value : me, tokenized as 'toSelf' to cheat a bit
A Time:Date of value

What we want to understand from this is :
"Return the value "name" of instances of class Foaf:Person' related to me
through instances of class prcd:PhoneCommunicationLog WITH VALUE INBOUND and add a constraint
of class Date:Time and value '2013'."

What do we learn from this?
=> temporals are 99% of the time CONSTRAINTS on the LINKING property
=> the difficulty is to understand it is an inbound call
=> toSelf allows this
=> PHONECALL is the only thing that can be linked TO SELF (we can't have a Person or Date)

STEP 4 CONCRETE SEMANTIC REPRESENTATION
STEP 5 SPARQL QUERY, results


# SOME HARDCORE QUERY... I dont think it'll ever work in the prototype
Combien d'appels de plus de dix minutes ai-je passé cette semaine avec Pierre?
STEP 1 TOKENIZE
STEP 2 VALUE
STEP 3 ABSTRACT SEMANTIC
STEP 4 CONCRETE SEMANTIC
STEP 5 SPARQL QUERY




Qui m'a écrit cette semaine ?
A qui ai-je écrit cette semaine ?
Quand pierre m'a viré de l'argent ?
Combien ai-je viré à Pierre ce mois-ci?
Quel est le numero de pierre ?
Quel est le numero de ma femme ?
