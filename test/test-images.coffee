chai = require 'chai'
chai.should()
#should = require 'should'
secret = require '../src/secret'
dinghy = require '../src/index'
fs = require 'fs'

describe 'Image Functions', ->
  describe 'showImage[s]', ->
    it 'should show a image when given id or slug', (done) ->
      dinghy.showImage '2118237', (e, o) ->
        o.status.should.equal 'OK'
        #console.log o
        done()
    it 'should list all available images', (done) ->
      dinghy.showImages (e, o) ->
        o.status.should.equal 'OK'
        #console.log o
        done()
