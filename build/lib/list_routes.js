var api_key, auth, base, client_id, colors, listDroplets, listSSHKeys, list_droplets_url, secret, ssh_keys_url, unirest;

unirest = require('unirest');

colors = require('colors');

colors.mode = 'console';

secret = require('../secret');

base = "https://api.digitalocean.com";

client_id = secret.client_id;

api_key = secret.api_key;

auth = "?client_id=" + client_id + "&api_key=" + api_key;

ssh_keys_url = "" + base + "/ssh_keys/" + auth;

list_droplets_url = "" + base + "/droplets/" + auth;

listSSHKeys = function() {
  return unirest.get(ssh_keys_url).as.json(function(res) {
    var ary, key, obj, str, _i, _len, _results;
    str = res.raw_body;
    obj = JSON.parse(str);
    ary = obj.ssh_keys;
    console.log("SSH Keys:");
    _results = [];
    for (_i = 0, _len = ary.length; _i < _len; _i++) {
      key = ary[_i];
      _results.push((function(key) {
        return console.log("" + key.name.blue + " (id: " + key.id + ")");
      })(key));
    }
    return _results;
  });
};

listDroplets = function() {
  return unirest.get(list_droplets_url).as.json(function(res) {
    var ary, droplet, obj, str, _i, _len, _results;
    str = res.raw_body;
    obj = JSON.parse(str);
    ary = obj.droplets;
    if (ary.empty != null) {
      return console.error("You dont have any Droplets");
    } else {
      _results = [];
      for (_i = 0, _len = ary.length; _i < _len; _i++) {
        droplet = ary[_i];
        _results.push((function(droplet) {
          var status_color;
          if (droplet.status === "active") {
            status_color = 'active'.green;
          } else {
            status_color = 'off'.red;
          }
          return console.log(droplet.name.blue + ' (ip: ' + droplet.ip_address + ', status: ' + status_color + ', region: ' + droplet.region_id + ', id: ' + droplet.id + ')');
        })(droplet));
      }
      return _results;
    }
  });
};

module.exports.listSSHKeys = listSSHKeys;

module.exports.listDroplets = listDroplets;
