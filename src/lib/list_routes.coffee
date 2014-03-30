unirest = require 'unirest'
colors  = require 'colors'
colors.mode = 'console'

secret = require '../secret'

# Global Variables
base = "https://api.digitalocean.com"
client_id = secret.client_id
api_key = secret.api_key
auth = "?client_id=#{client_id}&api_key=#{api_key}"

# List API endpoints
ssh_keys_url = "#{base}/ssh_keys/#{auth}"
list_droplets_url = "#{base}/droplets/#{auth}"

listSSHKeys = ->
  unirest.get(ssh_keys_url).as.json (res) ->
    str = res.raw_body
    obj = JSON.parse(str)
    ary = obj.ssh_keys
    console.log "SSH Keys:"
    for key in ary
      do (key) ->
        console.log "#{key.name.blue} (id: #{key.id})"

listDroplets = ->
  unirest.get(list_droplets_url).as.json (res) ->
    str = res.raw_body
    obj = JSON.parse(str)
    ary = obj.droplets

    if ary.empty?
      console.error "You dont have any Droplets"
    else
      for droplet in ary
        do (droplet) ->
          if droplet.status == "active"
            status_color = 'active'.green
          else
            status_color = 'off'.red
          console.log(droplet.name.blue + ' (ip: ' + droplet.ip_address + ', status: ' + status_color + ', region: ' + droplet.region_id + ', id: '+ droplet.id + ')')

module.exports.listSSHKeys = listSSHKeys
module.exports.listDroplets = listDroplets
