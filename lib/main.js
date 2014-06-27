(function() {
  var reporter;

  module.exports.from = require("./from");

  module.exports.to = require("./to");

  module.exports.verifiers = require("./verifiers");

  reporter = function(s) {
    var l, newL, stack, x, _i, _len;
    console.warn("Verifier error: " + s);
    stack = new Error().stack;
    l = stack.split("\n");
    newL = [];
    for (_i = 0, _len = l.length; _i < _len; _i++) {
      x = l[_i];
      if (x.indexOf("/node_modules/verify/") === -1 &&  x.indexOf("Error:") !== 0) {
        newL.push(x);
      }
    }
    return console.warn(newL.join("\n"));
  };

  module.exports.setReporter = function(x) {
    return reporter = x;
  };

  module.exports.getReporter = function() {
    return reporter;
  };

}).call(this);
