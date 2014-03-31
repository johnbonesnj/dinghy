#!/usr/local/bin/coffee

## Utility
fs = require 'fs'
_  = require 'lodash'

## CLI
prettyjson = require 'prettyjson'
colors  = require 'colors'
colors.mode = 'console'
parser = require 'nomnom'

## Config
package_json = require '../package.json'
secret = require './secret'

## Modules
dinghy = require('./index')
dinghy.setup(secret.client_id, secret.api_key)

## SSH Key functions
listKeys = (callback) ->
  dinghy.showKeys (e, o) ->
    if o.status is 'OK'
      key_obj = o
      console.log prettyjson.render key_obj
    else
      console.log "ERROR".red
      console.log o.status
showKey = (id) ->
  dinghy.showKey id, (e, o) ->
    if o.status is 'OK'
      key_obj = o
      console.log prettyjson.render key_obj
    else
      console.log "ERROR".red
      console.log o
addKey = (name, pub_key) ->
  test_pub_key = fs.readFileSync pub_key, 'utf8'
  temp_ssh_ids = []
  dinghy.addKey test_pub_key, name, (e, o) ->
    temp_ssh_ids.push(o.ssh_key.id)
    if o.status is 'OK'
      key= o.ssh_key
      ok = "OK".green
      console.log "{ status: '#{ok}', ssh_key: { id: #{key.id},\
                   name: '#{key.name}', ssh_pub_key: '#{key.ssh_pub_key}' } }"
    else
      console.log "ERROR".red
      console.log o.status
destroyKey = (id) ->
  dinghy.destroyKey id, (e, o) ->
    if o.status is 'OK'
      console.log prettyjson.render o
    else
      console.log "ERROR".red
      console.log o

## Droplet Functions



## Parser

parser.command('keys')
  .option('list', {
    abbr: 'l',
    flag: true,
    help: "List all keys"
    })
  .option('show', {
    abbr: 's',
    help: "List a key, with provided id"
    })
  .option('destroy', {
    abbr: 'd',
    help: "destroy a key, with provided id"
    })

  .callback (opts) ->
    if (opts.list)
      listKeys()
    else if (opts.show)
      showKey(opts.show)
    else if (opts.destroy)
      destroyKey(opts.destroy)

parser.command('add-key')
  .option('file', {
    position: 2,
    help: 'Path to Public SSH Key file.'
    })
  .option('name', {
    position: 1,
    help: 'Nickname for new SSH Key.'
    })
  .callback (opts) ->
    addKey(opts.name, opts.file)
    #console.log opts
  .help("run browser tests")

parser.parse()
