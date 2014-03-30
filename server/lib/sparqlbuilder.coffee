findsubjects = require './findsubjects'
module.exports = (concretetriple, variables, filters) ->


    constraints = []
    filters ?= ''
    # Find all subjects (select)


    # Find all constraints (where)
    constraints = concretetriple.map((e) -> "#{e.s} #{e.p} #{e.o}").join " . \n"

    sparql = """
            PREFIX foaf: <http://xmlns.com/foaf/0.1/>
            PREFIX prcd: <http://www.techtane.info/phonecommunicationlog.ttl#>
            PREFIX time: <http://www.w3.org/2006/time#>
            PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
            PREFIX rcp: <http://www.techtane.info/receipt.ttl#>
            PREFIX pdta: <http://www.techtane.info/personaldata.ttl#>
            PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
            PREFIX bko: <http://www.techtane.info/bankoperation.ttl#>
            PREFIX vod: <http://www.techtane.info/videoondemand.ttl#>
            SELECT #{variables.join(' ')}
            WHERE {
            #{constraints} .
            #{filters}
            }
            """

    return sparql