module.exports = (concretetriple) ->

  
    subjects = []
    constraints = []
    # Find all subjects (select)
    for t in concretetriple when t.s[0] is '?' 
        subjects.push t.s unless t.s in subjects

    # Find all constraints (where)
    constraints = concretetriple.map((e) -> "#{e.s} #{e.p} #{e.o}").join ". \n"
    
    sparql = """ 
            PREFIX foaf: <http://xmlns.com/foaf/0.1/>
            PREFIX pcrd: <http://www.techtane.info/phonecommunicationlog.ttl#>
            PREFIX time: <http://www.w3.org/2006/time#>
            PREFIX  xsd: <http://www.w3.org/2001/XMLSchema#>
            SELECT #{subjects.join(' ')}
            WHERE {#{constraints}}
            """

    return sparql