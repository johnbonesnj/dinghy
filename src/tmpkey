#!/usr/local/bin/coffee
_ = require 'lodash'
secret = require './secret'
dinghy = require './index'
fs = require 'fs'
colors  = require 'colors'
colors.mode = 'console'
parser = require "nomnom"

dinghy.setup secret.client_id, secret.api_key

test_pub_key = fs.readFileSync '../test/test_key.pub', 'utf8'
temp_ssh_ids = []

print = (ary) ->
  console.log ary

destroy = (ary) ->
  for key in ary
    do (key) ->
      dinghy.destroy_ssh_key key.id, (e, o) ->
        if (e)
          console.log "Error:".red
          console.log e
        else
          console.log o

listFancy = (callback) ->
  dinghy.all_ssh_keys (e, o) ->
    if o.status is 'OK'
      key_obj = o
      key_ary = o.ssh_keys
      #key_str = JSON.stringify(key_ary)
      # console.log key_ary
      if key_ary.length is 1
        console.log key_ary
      else
        for key in key_ary
          do (key) ->
            if key.name is 'id_rsa'
              console.log " id_rsa is untouched ".redBG
            else
              console.log "Key: ".red + key.name.yellow + " will be removed".red
    else
      console.log "ERROR".red
      console.log o.status

list = (callback) ->
  dinghy.all_ssh_keys (e, o) ->
    if o.status is 'OK'
      key_obj = o
      key_ary = o.ssh_keys
      unsafe = []
      for key in key_ary
        do (key) ->
          if key.name != 'id_rsa'
            unsafe.push(key)
      callback(unsafe)
    else
      console.log "ERROR".red
      console.log o.status

create = (count) ->
  _(count).times ->
    rand_int = _.random(1000, 1999)
    key_name = "Test_Key-#{rand_int}"
    dinghy.create_ssh_key test_pub_key, key_name, (e, o) ->
      temp_ssh_ids.push(o.ssh_key.id)
      if o.status is 'OK'
        key = o.ssh_key
        id = key.id
        name = key.name
        key_str = key.ssh_pub_key
        ok = "OK".green
        console.log "{ status: '#{ok}', ssh_key: { id: #{id}, name: '#{name}', ssh_pub_key: '#{key_str}' } }"
      else
        console.log "ERROR".red
        console.log o.status


parser.command('keys')
  .option('all', {
    abbr: 'a',
    flag: true,
    help: "List all keys"
    })
  .option('safe', {
    abbr: 's',
    flag: true,
    help: "List only temp keys"
    })
  .option('destroy', {
    abbr: 'd',
    flag: true,
    help: "destroy all temp keys"
    })
  .option('create', {
    abbr: 'c',
    help: "create temp <n> keys"
    })

  .callback (opts) ->
    if (opts.all)
      listFancy()
    else if (opts.safe)
      list(print)
    else if (opts.create)
      create(opts.create)
    else if (opts.destroy)
      list(destroy)

parser.parse()
