secret = require './secret'
dinghy = require './index'
fs = require 'fs'
colors  = require 'colors'
colors.mode = 'console'

test_pub_key = fs.readFileSync '../test/test_key.pub', 'utf8'
temp_ssh_ids = []

dinghy.setup secret.client_id, secret.api_key

# create
# dinghy.create_ssh_key test_pub_key, 'test_name', (e, o) ->
#   temp_ssh_ids.push(o.ssh_key.id)
#   if o.status is 'OK'
#     key= o.ssh_key
#     id = key.id
#     name = key.name
#     key_str = key.ssh_pub_key
#     ok = "OK".green
#     console.log "{ status: '#{ok}', ssh_key: { id: #{id}, name: '#{name}', ssh_pub_key: '#{key_str}' } }"
#   else
#     console.log "ERROR".red
#     console.log o.status

# list
dinghy.all_ssh_keys (e, o) ->
  if o.status is 'OK'
    key_ary = o
    key_str = JSON.stringify(key_ary)

    console.log key_ary
    console.log key_str
    # for key in key_ary
    #   do (key) ->
    #     id = key.id
    #     name = key.name
    #     ok = "OK".green
    #     console.log "{ status: '#{ok}', ssh_keys: [ { id: #{id}, name: '#{name}' } ] }"
  else
    console.log "ERROR".red
    console.log o.status

# destroy
# dinghy.destroy_ssh_key temp_ssh_ids[0], (e, o) ->
# dinghy.destroy_ssh_key '102716', (e, o) ->
