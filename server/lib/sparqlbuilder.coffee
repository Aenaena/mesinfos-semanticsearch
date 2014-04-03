findsubjects = require './findsubjects'
module.exports = (resultObject) ->

    # Find all constraints (where)
    variables = resultObject.subjects
    constraints = resultObject.concrete.map((e) -> "#{e.s} #{e.p} #{e.o}").join " . \n"
    filters = resultObject.filters.map((x) -> "FILTER(#{x})").join "\n"

    sparql = """
            PREFIX foaf: <http://xmlns.com/foaf/0.1/>
            PREFIX prcd: <http://www.techtane.info/phonecommunicationlog.ttl#>
            PREFIX time: <http://www.w3.org/2006/time#>
            PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
            PREFIX rcp: <http://www.techtane.info/receipt.ttl#>
            PREFIX rcpd: <http://www.techtane.info/receiptdetail.ttl#>
            PREFIX pdta: <http://www.techtane.info/personaldata.ttl#>
            PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
            PREFIX bko: <http://www.techtane.info/bankoperation.ttl#>
            PREFIX vod: <http://www.techtane.info/videoondemand.ttl#>
            PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>
            PREFIX my: <https://my.cozy.io/>
            SELECT #{variables.join(' ')}
            WHERE {
            #{constraints} .
            #{filters}
            }
            """

    return sparql