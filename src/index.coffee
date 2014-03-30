request = require 'request'


dinghy = {}
module.exports = dinghy

api_key = ""
client_id = ""
cred_str = ""
host_str = "https://api.digitalocean.com/"

client = require './lib/client'
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
  req = host_str + 'droplets' + cred_str
  request req, (e, o) ->
    o = o.body
    # console.log e, o
    callback e, o

# SSH Keys
dinghy.all_ssh_keys = (callback) ->
  # GET https://api.digitalocean.com/ssh_keys/?client_id=[client_id]&api_key=[api_key]
  req = host_str + '/ssh_keys/?' + cred_str
  client.send_request(req, callback)

dinghy.show_ssh_key = (id, callback) ->
  # GET https://api.digitalocean.com/ssh_keys/[ssh_key_id]/?client_id=[client_id]&api_key=[api_key]
  req = host_str + '/ssh_keys/' + "#{id}/?" + cred_str
  client.send_request(req, callback)

dinghy.create_ssh_key = (key, name, callback) ->
  # GET https://api.digitalocean.com/ssh_keys/new/?name=[ssh_key_name]&ssh_pub_key=[ssh_public_key]&client_id=[client_id]&api_key=[api_key]
  req = host_str + '/ssh_keys/new/?name=' + name + '&ssh_pub_key=' + key + '&' + cred_str
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

dinghy.destroy_ssh_key = (id, callback) ->
  # GET https://api.digitalocean.com/ssh_keys/[ssh_key_id]/destroy/?client_id=[client_id]&api_key=[api_key]
  req = host_str + "/ssh_keys/#{id}/destroy/?" + cred_str
  client.send_request(req, callback)

# Droplets
dinghy.get_ids = (callback) ->
  req = host_str + "/droplets/?" + cred_str
  client.send_request req, (e, o) ->
    if e
      callback e
    else
      ids = []
      o.droplets.forEach (machine) ->
        ids.push(machine.id)
      callback e, ids





dinghy.sizes = (callback) ->
  req = host_str + "/sizes/?" + cred_str
  client.send_request(req, callback)

