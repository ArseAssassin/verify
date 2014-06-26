(function() {
  var helpers, main;

  helpers = require("./helpers");

  main = require("./main");

  module.exports = function() {
    var args, argumentNames, f, validator, validators, _i, _len;
    args = Array.prototype.slice.call(arguments);
    f = args[args.length - 1];
    argumentNames = helpers.parseFunctionArguments(f);
    validators = args.splice(0, args.length - 1);
    for (_i = 0, _len = validators.length; _i < _len; _i++) {
      validator = validators[_i];
      if (!validator) {
        throw new Error("Invalid validator " + validator);
      }
    }
    return function() {
      var fArgs, k, s, v;
      fArgs = Array.prototype.slice.call(arguments);
      for (k in fArgs) {
        v = fArgs[k];
        s = validators[k](v);
        if (s !== true) {
          main.getReporter()("Validation error in argument " + arguments[k] + ", " + v + ": " + s);
        }
      }
      return f.apply(this, fArgs);
    };
  };

}).call(this);
