findsubjects = require './findsubjects'
module.exports = (concretetriple) ->

  
    subjects = findsubjects(concretetriple)
    console.log "HI", subjects
    constraints = []
    # Find all subjects (select)
    

    # Find all constraints (where)
    constraints = concretetriple.map((e) -> "#{e.s} #{e.p} #{e.o}").join ". \n"

    sparql = """ 
            PREFIX foaf: <http://xmlns.com/foaf/0.1/>
            PREFIX prcd: <http://www.techtane.info/phonecommunicationlog.ttl#>
            PREFIX time: <http://www.w3.org/2006/time#>
            PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
            PREFIX rcp: <http://www.techtane.info/receipt.ttl#>
            PREFIX pdta: <http://www.techtane.info/personaldata.ttl#>
            PREFIX bko: <http://www.techtane.info/bankoperation.ttl#>
            SELECT #{subjects.join(' ')}
            WHERE {
            #{constraints}.
            }
            """

    return sparql