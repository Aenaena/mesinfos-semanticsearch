require 'should'
vodnamescrapper = require '../../server/lib/vodnamescrapper'

describe 'Amazing scrapper', ->
    it 'should return a title', (done) ->
        vodnamescrapper 'GOSSIPGX305W0072689V', (error, title) ->
            title.should.equal 'Gossip Girl S3 '
            done()