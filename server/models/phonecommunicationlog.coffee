americano = require 'americano-cozy'

module.exports = PhoneCommunicationLog = americano.getModel 'phonecommunicationlog',
    'origin': String
    'idMesInfos': String
    'direction': String
    'timestamp': Date
    'subscriberNumber': String
    'correspondantNumber': String
    'chipCount': Number
    'chipType': String
    'type': String
    'imsi': { 'type': String, 'default': null }
    'imei': { 'type': String, 'default': null }
    'latitude': Number
    'longitude': Number
    'snippet': String