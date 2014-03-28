# For words which are not directly tokenized we need to check the value
# because they are INSTANCES
# Is it a Foaf:Person ? 
# Is it a place? (geolocalisation)
# Is it a number? (price tag, complex)
# We could add dates, but they can be built with tokens only

## First step is to detect persons

## Second step is to detect numbers


# we need to return a hash 
# h = {}
# h[class] =  which is a triple declaring the class evaluated
# h[property] = the value which was passed semantized as a triple