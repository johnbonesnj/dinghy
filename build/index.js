var api_key, client, client_id, colors, cred_str, dinghy, host_str, ids_created_this_session, request, secret, ssh_ids_created_this_session;

request = require('request');

colors = require('colors');

colors.mode = 'console';

secret = require('./secret');

dinghy = {};

module.exports = dinghy;

api_key = "";

client_id = "";

cred_str = "";

host_str = "https://api.digitalocean.com/";

client = require('./lib/client');

ids_created_this_session = [];

ssh_ids_created_this_session = [];

dinghy.setup = function(c_client_id, c_api_key) {
  api_key = c_api_key;
  client_id = c_client_id;
  cred_str = "client_id=" + client_id + "&api_key=" + api_key;
  return client.setup(host_str, cred_str);
};

dinghy.documentation = function(callback) {
  var req;
  req = host_str + 'droplets' + cred_str;
  return request(req, function(e, o) {
    o = o.body;
    return callback(e, o);
  });
};

dinghy.all_ssh_keys = function(callback) {
  var req;
  req = host_str + '/ssh_keys/?' + cred_str;
  return client.send_request(req, callback);
};

dinghy.show_ssh_key = function(id, callback) {
  var req;
  req = host_str + '/ssh_keys/' + ("" + id + "/?") + cred_str;
  return client.send_request(req, callback);
};

dinghy.create_ssh_key = function(key, name, callback) {
  var req;
  req = host_str + '/ssh_keys/new/?name=' + name + '&ssh_pub_key=' + key + '&' + cred_str;
  return client.send_request(req, function(e, o) {
    var id, t_id;
    if (Array.isArray(o)) {
      for (key in o) {
        if (o[key].status === 'OK') {
          id = o[key].ssh_key.id;
          ssh_ids_created_this_session.push(id);
        }
      }
    } else {
      if (o.status === 'OK') {
        t_id = o.ssh_key.id;
        ssh_ids_created_this_session.push(t_id);
      }
    }
    return callback(e, o);
  });
};

dinghy.destroy_ssh_key = function(id, callback) {
  var req;
  req = host_str + ("/ssh_keys/" + id + "/destroy/?") + cred_str;
  return client.send_request(req, callback);
};

dinghy.get_ids = function(callback) {
  var req;
  req = host_str + "/droplets/?" + cred_str;
  return client.send_request(req, function(e, o) {
    var ids;
    if (e) {
      return callback(e);
    } else {
      ids = [];
      o.droplets.forEach(function(machine) {
        return ids.push(machine.id);
      });
      return callback(e, ids);
    }
  });
};

dinghy.sizes = function(callback) {
  var req;
  req = host_str + "/sizes/?" + cred_str;
  return client.send_request(req, callback);
};
