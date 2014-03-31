chai = require 'chai'
chai.should()
#should = require 'should'
secret = require '../src/secret'
dinghy = require '../src/index'
fs = require 'fs'


before (done) ->
  dinghy.setup secret.client_id, secret.api_key
  done()

test_pub_key = fs.readFileSync './test/test_key.pub', 'utf8'

temp_ids = ""
new_droplet_multi =
  droplets: [
    {
      name: "test2"
      size_id: 66
      image_id: 25306
      region_id: 1
    }
    {
      name: "test3"
      size_id: 66
      image_id: 25306
      region_id: 1
    }
  ]
new_droplet =
  name: "test1"
  size_id: 66
  image_id: 25306
  region_id: 1

test_droplet_ids = 0
temp_ssh_ids = []

describe 'Basic List Functions', ->
  describe 'events', ->
    describe 'showEvents', ->
      it 'should return No Event Found when given wrong id', (done) ->
        dinghy.showEvents '12234', (e, o) ->
          o.should.equal 'No Event Found'
          done()
  describe 'sizes', ->
    describe 'showSizes', ->
      it 'should be able to list sizes', (done) ->
        dinghy.showSizes (e, o) ->
          o.status.should.equal 'OK'
          #console.log o
          done()
  describe 'regions', ->
    describe 'showRegions', ->
      it 'should list all available regions', (done) ->
        dinghy.showRegions (e, o) ->
          o.status.should.equal 'OK'
          done()
