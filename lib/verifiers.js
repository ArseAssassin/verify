(function() {
  var main, verifier;

  main = require("./main");

  verifier = function(error, f) {
    return function(n) {
      if (f(n) === false) {
        return error;
      } else {
        return true;
      }
    };
  };

  module.exports = {
    num: verifier("needs to be a number", function(n) {
      return typeof n === "number";
    }),
    string: verifier("needs to be a string", function(n) {
      return typeof n === "string";
    }),
    object: verifier("needs to be an object", function(n) {
      return n !== null && typeof n === "object";
    }),
    bool: verifier("needs to be a boolean", function(n) {
      return typeof n === "boolean";
    }),
    arrayOf: function(verifier) {
      if (!verifier) {
        main.getReporter()("Invalid verifier for arrayOf: " + verifier);
      }
      return function(n) {
        var s, x, _i, _len;
        s = module.exports.array(n);
        if (s !== true) {
          return s;
        } else {
          for (_i = 0, _len = n.length; _i < _len; _i++) {
            x = n[_i];
            s = verifier(x);
            if (s !== true) {
              return "array verification needs to pass on " + x + ": " + s;
            }
          }
          return true;
        }
      };
    },
    blueprint: function(base) {
      var field;
      for (field in base) {
        verifier = base[field];
        if (typeof verifier === "object") {
          base[field] = module.exports.blueprint(verifier);
        } else if (typeof verifier !== "function") {
          main.getReporter()("Invalid verifier for field " + field + ": " + verifier);
        }
      }
      return function(n, secondary_matcher) {
        var fieldName, fieldValue, s, value;
        if (secondary_matcher == null) {
          secondary_matcher = null;
        }
        for (field in base) {
          verifier = base[field];
          value = n[field];
          if (secondary_matcher !== null) {
            s = secondary_matcher(verifier)(value, secondary_matcher);
            if (s !== true) {
              return "blueprint verification needs to pass on field " + field + ": " + s;
            }
          } else {
            s = verifier(value);
            if (s !== true) {
              return "blueprint verification needs to pass on field " + field + ": " + s;
            }
          }
        }
        for (fieldName in n) {
          fieldValue = n[fieldName];
          if (!base[fieldName]) {
            return "field " + fieldName + " present in value, but not in blueprint";
          }
        }
        return true;
      };
    },
    partial: function(blueprint) {
      return function(n) {
        return blueprint(n, module.exports.undefinable);
      };
    },
    array: verifier("needs to be an array", function(n) {
      return n instanceof Array;
    }),
    nullable: function(verifier) {
      return function(n, secondary_matcher) {
        if (secondary_matcher == null) {
          secondary_matcher = null;
        }
        return n === null || verifier(n, secondary_matcher);
      };
    },
    undefinable: function(verifier) {
      return function(n, secondary_matcher) {
        if (secondary_matcher == null) {
          secondary_matcher = null;
        }
        return n === void 0 || verifier(n, secondary_matcher);
      };
    },
    equal: (function(x) {
      return module.exports.verifier("needs to equal " + x, (function(n) {
        return n === x;
      }));
    }),
    "function": verifier("needs to be a function", function(n) {
      return typeof n === "function";
    }),
    "enum": function() {
      var value, verifiers, _i, _len, _ref;
      verifiers = [];
      _ref = Array.prototype.slice.call(arguments);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        value = _ref[_i];
        verifiers.push(module.exports.equal(value));
      }
      return module.exports.either.apply(this, verifiers);
    },
    either: function() {
      var verifiers;
      verifiers = Array.prototype.slice.call(arguments);
      return function(n) {
        var l, s, _i, _len;
        l = [];
        for (_i = 0, _len = verifiers.length; _i < _len; _i++) {
          verifier = verifiers[_i];
          s = verifier(n);
          l.push(s);
        }
        if (l.indexOf(true) > -1) {
          return true;
        } else {
          return l.join(" or ");
        }
      };
    },
    and: function() {
      var verifiers;
      verifiers = Array.prototype.slice.call(arguments);
      return function(n) {
        var l, value, _i, _j, _len, _len1;
        l = [];
        for (_i = 0, _len = verifiers.length; _i < _len; _i++) {
          verifier = verifiers[_i];
          l.push(verifier(n));
        }
        for (_j = 0, _len1 = l.length; _j < _len1; _j++) {
          value = l[_j];
          if (value !== true) {
            return l.join(" and ");
          }
        }
        return true;
      };
    },
    verifier: verifier
  };

}).call(this);
