chai = require 'chai'
chai.should()
#should = require 'should'
secret = require '../src/secret'
dinghy = require '../src/index'
fs = require 'fs'

before (done) ->
  dinghy.setup secret.client_id, secret.api_key
  done()

describe 'Droplet Functions', ->
  describe 'get_ids', ->
    it 'should return array of droplet ids', (done) ->
      dinghy.get_ids (e, o) ->
        #console.log o
        o.should.be.Array?
        done()
  describe 'showDroplet[s]', ->
    it 'should return droplet when given id', (done) ->
      id = '1364556'
      dinghy.showDroplet id, (e, o) ->
        #console.log o
        o.status.should.equal 'OK'
        done()
    it 'should return droplets object', (done) ->
      dinghy.showDroplets (e, o) ->
        o.status.should.equal 'OK'
        #console.log o
        done()
