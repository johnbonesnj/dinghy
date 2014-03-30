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
new_droplet_multi = droplets: [
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


describe 'documentation', ->
  it 'should be able to display', (done) ->
    dinghy.documentation (e, o) ->
      o.should.be.String?
      done()

  it 'should be able to list sizes', (done) ->
    dinghy.showSizes (e, o) ->
      o.status.should.equal 'OK'
      #console.log o
      done()

describe 'create functions', ->
  describe 'ssh keys', ->
    it 'should create a key when given name and public key', (done) ->
      dinghy.addKey test_pub_key, 'test_name', (e, o) ->
        o.status.should.equal 'OK'
        #console.log o
        temp_ssh_ids.push(o.ssh_key.id)
        done()

describe 'list', ->
  describe 'ssh keys', ->
    it 'should list all ssh keys', (done) ->
      dinghy.showKeys (e, o) ->
        o.status.should.equal 'OK'
        #console.log o
        done()
    it 'should list single ssh key when given id', (done) ->
      dinghy.showKey temp_ssh_ids[0], (e, o) ->
        o.status.should.equal 'OK'
        #console.log o
        done()
  describe 'events', ->
    it 'should return No Event Found when given wrong id', (done) ->
      dinghy.showEvents '12234', (e, o) ->
        o.should.equal 'No Event Found'
        done()
  describe 'regions', ->
    it 'should list all available regions', (done) ->
      dinghy.showRegions (e, o) ->
        o.status.should.equal 'OK'
        done()
  describe 'images', ->
    it 'should list all available images', (done) ->
      dinghy.showImages (e, o) ->
        o.status.should.equal 'OK'
        #console.log o
        done()
    it 'should show a image when given id or slug', (done) ->
      dinghy.showImage '2118237', (e, o) ->
        o.status.should.equal 'OK'
        #console.log o
        done()
  describe 'droplets', ->
    it 'should return array of droplet ids', (done) ->
      dinghy.get_ids (e, o) ->
        #console.log o
        o.should.be.Array?
        done()
    it 'should return droplets object', (done) ->
      dinghy.showDroplets (e, o) ->
        o.status.should.equal 'OK'
        #console.log o
        done()
    it 'should return droplet when given id', (done) ->
      id = '1364556'
      dinghy.showDroplet id, (e, o) ->
        #console.log o
        o.status.should.equal 'OK'
        done()

describe 'destroy functions', ->
  describe 'ssh keys', ->
    it 'should destroy a ssh key when given id', (done) ->
      dinghy.destroyKey temp_ssh_ids[0], (e, o) ->
      # dinghy.destroy_ssh_key '102716', (e, o) ->
        o.status.should.equal 'OK'
        #console.log "destroy_ssh_key Results: #{o.status}"
        done()
