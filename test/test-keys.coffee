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
temp_ssh_ids = []

describe 'SSH Key Functions', ->
  describe 'addKey', ->
    it 'should create a key when given name and public key', (done) ->
      dinghy.addKey test_pub_key, 'test_name', (e, o) ->
        o.status.should.equal 'OK'
        #console.log o
        temp_ssh_ids.push(o.ssh_key.id)
        done()

  describe 'showKey[s]', ->
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

  describe 'destroyKey', ->
    it 'should destroy a ssh key when given id', (done) ->
      dinghy.destroyKey temp_ssh_ids[0], (e, o) ->
      # dinghy.destroy_ssh_key '102716', (e, o) ->
        o.status.should.equal 'OK'
        #console.log "destroy_ssh_key Results: #{o.status}"
        done()
