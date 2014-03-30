var async, client, cred_str, host_str, request;

request = require('request');

async = require('async');

client = {};

module.exports = client;

host_str = "";

cred_str = "";

client.setup = function(c_host_str, c_cred_str) {
  host_str = c_host_str;
  cred_str = c_cred_str;
  return true;
};

client.send_request = function(urls, callback) {
  var req;
  req = function(url, callback) {
    return request(url, function(e, o) {
      o = JSON.parse(o.body);
      if (o.status === "ERROR") {
        return callback(o.status, o.error_message);
      } else {
        return callback(e, o);
      }
    });
  };
  if (Array.isArray(urls)) {
    return async.map(urls, req, function(e, r) {
      return callback(e, r);
    });
  } else {
    return req(urls, callback);
  }
};

client.build_requests = function(type, api_path, arg) {
  var item, req;
  if (type === void 0) {
    type = "/";
  }
  if (Array.isArray(arg)) {
    req = [];
    for (item in arg) {
      reqs.push(host_str + "/" + type + "/" + arg[item] + "/" + api_path + "/" + cred_str);
    }
    return reqs;
  } else {
    return host_str + "/" + type + "/" + arg + "/" + api_path + "/" + cred_string;
  }
};

client.build_machine_req = function(machine) {
  var ret;
  ret = "/new?name=" + machine.name + "&size_id=" + machine.size_id + "&image_id=" + machine.image_id + "&region_id=" + machine.region_id + "&" + cred_str;
  if (machine.hasOwnProperty("ssh_key_ids")) {
    ret += "&ssh_key_ids=" + machine.ssh_key_ids;
  }
  return ret;
};
