americano = require 'americano-cozy'

module.exports = ReceiptDetail = americano.getModel 'receiptdetail',
    'origin': String,
    'order': Number,
    'barcode': String,
    'label': String,
    'family': String,
    'familyLabel': String,
    'section': String,
    'sectionLabel': String,
    'amount': Number,
    'price': Number,
    'type': String,
    'typeLabel': String,
    'receiptId': String,
    'intermarcheShopId': String,
    'timestamp': Date,
    'isOnlineBuy': Boolean,

ReceiptDetail.batchSize = 100
ReceiptDetail.indexFields = []

ReceiptDetail::toRDFGraph = (rdf) ->
    graph = rdf.makeGraph()
    nodeName = rdf.modelName this
    graph.add rdf.makeTriple nodeName, "a", "rcpd:ReceiptDetail"
    graph.add rdf.makeTriple nodeName, "rcpd:hasReceiptId", rdf.makeString @receiptId
    graph.add rdf.makeTriple nodeName, "rcpd:hasFamilyLabel", rdf.makeString(ReceiptDetail.labels[@section] or 'AUTRE')
    graph.add rdf.makeTriple nodeName, "rcpd:hasPrice", rdf.makeFloat this.price
    # graph.add rdf.makeTriple nodeName, "rdfs:seeAlso", "http://fr.openfoodfacts.org/api/v0/produit/#{barcode}.json"
    rdf.addDatetime graph, this, new Date(this.timestamp)
    return graph

ReceiptDetail::aroundSPARQL = ->
    """
    PREFIX rcpd: <http://www.techtane.info/receiptdetail.ttl#>
    PREFIX rcp: <http://www.techtane.info/receipt.ttl#>
    PREFIX time: <http://www.w3.org/2006/time#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX my: <https://my.cozy.io/>
    SELECT ?family ?product ?receipt ?instant
    WHERE {
        ?receipt rcp:hasReceiptId ?id .
        ?product rcpd:hasReceiptId ?id .
        ?product rcpd:hasFamilyLabel ?family .
        ?receipt time:hasInstant/time:inDateTime ?instant .
        FILTER(?product = my:#{@_id}) .
    }
    """

getBarcode = (rdet) ->
    return rdet.barcode unless rdet.barcode?.length is 12
    even = 0
    odd = 0
    for i in [0..5]
        odd += parseInt rdet.barcode[2 * i]
        even += parseInt rdet.barcode[2 * i + 1]

    checksum = 10 - ( 3 * even + odd ) % 10
    return rdet.barcode + checksum.toString()

ReceiptDetail.labels =
    '12' :'BOUL PAT TRAD',
    '10' :'FROMAGE TRAD',
    '70' :'NON COMMERCIALE',
    '38' :'SURGELES',
    '66' :'PRESTATION DE SERVICE',
    '50' :'TEXTILE',
    '28' :'SAURISSERIE',
    '44' :'ALIMENTATION POUR ANIMAUX',
    '48' :'D.P.H.',
    '60' :'BAZAR LEGER',
    '30' :'CREMERIE LS',
    '22' :'BOUCHERIE FRAIS EMB.',
    '32' :'PAIN PAT LS INDUS',
    '20' :'BOUCHERIE LS',
    '34' :'FRUITS ET LEGUMES',
    '26' :'CHARCUTERIE TRAITEUR LS',
    '36' :'FLEURS ET PLANTES',
    '24' :'VOLAILLE LS',
    '2' :'BOUCHERIE / VOLAILLE TRAD',
    '46' :'LIQUIDES',
    '4' :'CHARCUTERIE TRAD',
    '6' :'TRAITEUR TRAD',
    '88' :'BOUTIQUE SERVICES',
    '8' :'PRODUITS DE LA MER TRAD',
    '40' :'EPICERIE SUCREE',
    '42' :'EPICERIE SALEE',
    '64' :'PRODUITS CULTURELS',
    '80' :'BOUTIQUE STATION',
    '82' :'BOUTIQUE PRESSE',
    '62' :'BAZAR TECHNIQUE',
    '200': 'BOUCHERIE',
    '24': 'BOUCHERIE',
    '20': 'BOUCHERIE',
    '22': 'BOUCHERIE',
    '2': 'BOUCHERIE',
    '12': 'BOULANGERIE',
    '32': 'BOULANGERIE',
    '26': 'CHARCUTERIE',
    '4': 'CHARCUTERIE',
    '8': 'POISSONERIE'
    '28': 'POISSONERIE'
    '120': 'BOULANGERIE',
    '260': 'CHARCUTERIE',
    '280': 'POISSONERIE'