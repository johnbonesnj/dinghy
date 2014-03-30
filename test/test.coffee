should = require 'should'
secret = require '../build/secret'
dinghy = require '../build/index'
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
    dinghy.sizes (e, o) ->
      o.status.should.equal 'OK'
      console.log o
      done()

describe 'create functions', ->
  describe 'ssh keys', ->
    it 'should create a key when given name and public key', (done) ->
      dinghy.create_ssh_key test_pub_key, 'test_name', (e, o) ->
        o.status.should.equal 'OK'
        console.log o
        temp_ssh_ids.push(o.ssh_key.id)
        done()

describe 'list functions', ->
  describe 'ssh keys', ->
    it 'should list all ssh keys', (done) ->
      dinghy.all_ssh_keys (e, o) ->
        o.status.should.equal 'OK'
        console.log o
        done()

    it 'should list single ssh key when given id', (done) ->
      dinghy.show_ssh_key '45398', (e, o) ->
        o.status.should.equal 'OK'
        console.log o
        done()


describe 'destroy functions', ->
  describe 'ssh keys', ->
    it 'should destroy a ssh key when given id', (done) ->
      dinghy.destroy_ssh_key temp_ssh_ids[0], (e, o) ->
      # dinghy.destroy_ssh_key '102716', (e, o) ->
        o.status.should.equal 'OK'
        console.log "destroy_ssh_key Results: #{o.status}"
        done()