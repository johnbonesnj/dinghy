var dinghy, fs, new_droplet, new_droplet_multi, secret, should, temp_ids, temp_ssh_ids, test_droplet_ids, test_pub_key;

should = require('should');

secret = require('../build/secret');

dinghy = require('../build/index');

fs = require('fs');

before(function(done) {
  dinghy.setup(secret.client_id, secret.api_key);
  return done();
});

test_pub_key = fs.readFileSync('./test/test_key.pub', 'utf8');

temp_ids = "";

new_droplet_multi = {
  droplets: [
    {
      name: "test2",
      size_id: 66,
      image_id: 25306,
      region_id: 1
    }, {
      name: "test3",
      size_id: 66,
      image_id: 25306,
      region_id: 1
    }
  ]
};

new_droplet = {
  name: "test1",
  size_id: 66,
  image_id: 25306,
  region_id: 1
};

test_droplet_ids = 0;

temp_ssh_ids = [];

describe('documentation', function() {
  it('should be able to display', function(done) {
    return dinghy.documentation(function(e, o) {
      o.should.be.String != null;
      return done();
    });
  });
  return it('should be able to list sizes', function(done) {
    return dinghy.sizes(function(e, o) {
      o.status.should.equal('OK');
      console.log(o);
      return done();
    });
  });
});

describe('create functions', function() {
  return describe('ssh keys', function() {
    return it('should create a key when given name and public key', function(done) {
      return dinghy.create_ssh_key(test_pub_key, 'test_name', function(e, o) {
        o.status.should.equal('OK');
        console.log(o);
        temp_ssh_ids.push(o.ssh_key.id);
        return done();
      });
    });
  });
});

describe('list functions', function() {
  return describe('ssh keys', function() {
    it('should list all ssh keys', function(done) {
      return dinghy.all_ssh_keys(function(e, o) {
        o.status.should.equal('OK');
        console.log(o);
        return done();
      });
    });
    return it('should list single ssh key when given id', function(done) {
      return dinghy.show_ssh_key('45398', function(e, o) {
        o.status.should.equal('OK');
        console.log(o);
        return done();
      });
    });
  });
});

describe('destroy functions', function() {
  return describe('ssh keys', function() {
    return it('should destroy a ssh key when given id', function(done) {
      return dinghy.destroy_ssh_key(temp_ssh_ids[0], function(e, o) {
        o.status.should.equal('OK');
        console.log("destroy_ssh_key Results: " + o.status);
        return done();
      });
    });
  });
});
