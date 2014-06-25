(function() {
  module.exports = function() {
    var args, f, validator, validators, _i, _len;
    args = Array.prototype.slice.call(arguments);
    f = args[args.length - 1];
    validators = args.splice(0, args.length - 1);
    for (_i = 0, _len = validators.length; _i < _len; _i++) {
      validator = validators[_i];
      if (!validator) {
        throw new Error("Invalid validator " + validator);
      }
    }
    return function() {
      var fArgs, k, v;
      fArgs = Array.prototype.slice.call(arguments);
      for (k in fArgs) {
        v = fArgs[k];
        if (!validators[k](v)) {
          console.log("Validation error in object", v);
          throw new Error("Validation error: argument " + k + " " + v);
        }
      }
      return f.apply(null, fArgs);
    };
  };

}).call(this);
