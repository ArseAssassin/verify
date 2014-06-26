(function() {
  var reporter;

  module.exports.from = require("./from");

  module.exports.to = require("./to");

  module.exports.verifiers = require("./verifiers");

  reporter = function(s) {
    console.log("Verifier error: " + s);
    return console.log(new Error().stack);
  };

  module.exports.setReporter = function(x) {
    return reporter(x);
  };

  module.exports.getReporter = function() {
    return reporter;
  };

}).call(this);
