request = require 'request'
async = require 'async'

client = {}
module.exports = client

host_str = ""
cred_str = ""

client.setup = (c_host_str, c_cred_str) ->
  host_str = c_host_str
  cred_str = c_cred_str
  true

client.send_request = (urls, callback) ->
  #console.log(urls)
  req = (url, callback) ->
    request url, (e, o) ->
      o = JSON.parse(o.body)
      if o.status is "ERROR"
        callback o.status, o.error_message
      else
        callback e, o
  if Array.isArray(urls)
    async.map urls, req, (e, r) ->
      callback e, r
  else
    req urls, callback

client.build_requests = (type, api_path, arg) ->
  type = "/" if type is undefined
  if Array.isArray(arg)
    req = []
    for item of arg
      reqs.push host_str + "/" + type + "/" + arg[item] + "/" + api_path + "/" + cred_str
    reqs
  else
    host_str + "/" + type + "/" + arg + "/" + api_path + "/" + cred_string

# name Required, String, this is the name of the droplet - must be formatted by hostname rules
# size_id Required, Numeric, this is the id of the size you would like the droplet created at
# image_id Required, Numeric, this is the id of the image you would like the droplet created with
# region_id Required, Numeric, this is the id of the region you would like your server in IE: US/Amsterdam
# ssh_key_ids Optional, Numeric CSV, comma separated list of ssh_key_ids that you would like to be added to the server
client.build_machine_req = (machine) ->
  ret = "/new?name=" + machine.name + "&size_id=" + machine.size_id + "&image_id=" + machine.image_id + "&region_id=" + machine.region_id + "&" + cred_str
  ret += ("&ssh_key_ids=" + machine.ssh_key_ids)  if machine.hasOwnProperty("ssh_key_ids")
  ret