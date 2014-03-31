dbpediaclient = require '../dbpediaclient.coffee'

module.exports(firstname, lastname)->

  query = """SELECT ?property ?hasValue
  WHERE {
   <http://dbpedia.org/resource/#{firstname}_#{lastname}> ?property ?hasValue .
  ?property rdfs:range foaf:Image .
  }
  """
  # inject query into dbpedia client
  # parse XML response for thumbnail URI
  # return URI



