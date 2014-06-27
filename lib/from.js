(function() {
  var helpers, main;

  helpers = require("./helpers");

  main = require("./main");

  module.exports = function() {
    var args, argumentNames, f, getArgument, k, validator, validators;
    args = Array.prototype.slice.call(arguments);
    getArgument = function(index) {
      return argumentNames[index] ||  index;
    };
    f = args[args.length - 1];
    if (!f || !f.apply) {
      main.getReporter()("Invalid function to verify: " + f);
    }
    argumentNames = helpers.parseFunctionArguments(f);
    validators = args.splice(0, args.length - 1);
    for (k in validators) {
      validator = validators[k];
      if (!validator) {
        main.getReporter()("Invalid verifier for argument " + (getArgument(k)) + ": " + validator);
      }
    }
    return function() {
      var fArgs, s, v;
      fArgs = Array.prototype.slice.call(arguments);
      for (k in validators) {
        validator = validators[k];
        v = fArgs[k];
        s = validator(v);
        if (s !== true) {
          main.getReporter()("Verification error in argument " + (getArgument(k)) + ", " + v + ": " + s);
        }
      }
      return f.apply(this, fArgs);
    };
  };

}).call(this);
