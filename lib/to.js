(function() {
  var main;

  main = require("./main");

  module.exports = function(verifier, f) {
    var name;
    name = "anonymous";
    if (f !== null && f !== void 0 && f.name) {
      name = f.name;
    }
    if (!verifier) {
      main.getReporter()("Error setting up return value of function " + name + ": verifier is " + verifier);
    }
    if (!f) {
      main.getReporter()("Error setting up return value: function is " + f);
    }
    return function() {
      var fArgs, r, s;
      fArgs = Array.prototype.slice.call(arguments);
      r = f.apply(this, fArgs);
      s = verifier(r);
      if (s !== true) {
        main.getReporter()("Error verifying return value of function " + name + ": " + s);
      }
      return r;
    };
  };

}).call(this);
