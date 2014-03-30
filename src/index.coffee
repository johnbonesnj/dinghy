request = require 'request'
client = require './lib/client'
_ = require 'lodash'

dinghy = {}
module.exports = dinghy

api_key = ""
client_id = ""
cred_str = ""
host_str = "https://api.digitalocean.com"

ids_created_this_session = []
ssh_ids_created_this_session = []

dinghy.setup = (c_client_id, c_api_key) ->
  api_key = c_api_key
  client_id = c_client_id
  cred_str = "client_id=#{client_id}&api_key=#{api_key}"
  # console.log host_str + cred_str
  client.setup(host_str, cred_str)

# Documentation
dinghy.documentation = (callback) ->
  req = "#{host_str}/droplets/#{cred_str}"
  request req, (e, o) ->
    o = o.body
    # console.log e, o
    callback e, o

# SSH Keys
dinghy.showKeys = (callback) ->
  #/ssh_keys/?cred_str
  req = "#{host_str}/ssh_keys/?#{cred_str}"
  client.send_request(req, callback)

dinghy.showKey = (id, callback) ->
  #/ssh_keys/[ssh_key_id]/?cred_str
  req = "#{host_str}/ssh_keys/#{id}/?#{cred_str}"
  client.send_request(req, callback)

dinghy.addKey = (key, name, callback) ->
  #/ssh_keys/new/?name=[ssh_key_name]&ssh_pub_key=[ssh_public_key]&cred_str
  req = "#{host_str}/ssh_keys/new/?name=#{name}&ssh_pub_key=#{key}&#{cred_str}"
  client.send_request req, (e, o) ->
    # adds to a local array of ssh_ids
    if Array.isArray(o)
      for key of o
        if o[key].status is 'OK'
          id = o[key].ssh_key.id
          ssh_ids_created_this_session.push(id)
    else
      if o.status is 'OK'
        t_id = o.ssh_key.id
        ssh_ids_created_this_session.push(t_id)
    callback e, o

dinghy.destroyKey = (id, callback) ->
  #/ssh_keys/[ssh_key_id]/destroy/?cred_str
  req = host_str + "/ssh_keys/#{id}/destroy/?" + cred_str
  client.send_request(req, callback)

# Droplets
dinghy.showDroplets = (callback) ->
  req = "#{host_str}/droplets/?#{cred_str}"
  client.send_request req, callback

dinghy.get_ids = (callback) ->
  req = "#{host_str}/droplets/?#{cred_str}"
  client.send_request req, (e, o) ->
    if e
      callback e
    else
      ids = []
      o.droplets.forEach (machine) ->
        ids.push(machine.id)
      callback e, ids

dinghy.showDroplet = (id, callback) ->
  #/ssh_keys/[ssh_key_id]/?cred_str
  req = "#{host_str}/droplets/#{id}/?#{cred_str}"
  client.send_request(req, callback)
# Images
dinghy.showImages = (callback) ->
  # /images/?
  req = "#{host_str}/images/?#{cred_str}"
  client.send_request(req, callback)
dinghy.showImage = (image_id_or_slug, callback) ->
  req = "#{host_str}/images/#{image_id_or_slug}/?#{cred_str}"
  client.send_request(req, callback)

# Events
dinghy.showEvents = (id, callback) ->
  # /events/[event_id]/?
  req = "#{host_str}/events/#{id}/?#{cred_str}"
  client.send_request(req, callback)

# Regions
dinghy.showRegions = (callback) ->
  # /regions/?
  req = "#{host_str}/regions/?#{cred_str}"
  client.send_request(req, callback)

# Droplet Available Sizes
dinghy.showSizes = (callback) ->
  req = host_str + "/sizes/?" + cred_str
  client.send_request(req, callback)
