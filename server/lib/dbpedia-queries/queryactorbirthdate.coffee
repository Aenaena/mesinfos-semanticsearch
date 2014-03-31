dbpediaclient = require '../dbpediaclient.coffee'

module.exports(firstname, lastname)->

  query = """SELECT ?property ?hasValue
  WHERE {
   <http://dbpedia.org/resource/#{firstname}_#{lastname}> ?property ?hasValue .
  ?property rdfs:range xsd:date .
  }
  """
  # inject query into dbpedia client
  # parse XML response for birth date
  # return birth date



