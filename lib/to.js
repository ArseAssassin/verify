(function() {
  module.exports = function(verifier, f) {
    return function() {
      var fArgs, r, s;
      fArgs = Array.prototype.slice.call(arguments);
      r = f.apply(this, fArgs);
      s = verifier(r);
      if (s !== true) {
        throw new Error("Error verifying return value of function " + f.name + ": " + s);
      }
      return r;
    };
  };

}).call(this);
