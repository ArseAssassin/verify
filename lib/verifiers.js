(function() {
  var verifier;

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
    num: verifier("value needs to be a number", function(n) {
      return typeof n === "number";
    }),
    string: verifier("value needs to be a string", function(n) {
      return typeof n === "string";
    }),
    object: verifier("value needs to be an object", function(n) {
      return n !== null && typeof n === "object";
    }),
    arrayOf: function(verifier) {
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
              return "array verification needs to pass on value " + x + ": " + s;
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
          throw new Error("Invalid verifier for field " + field + ": " + verifier);
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
          if (secondary_matcher) {
            s = secondary_matcher(verifier)(value);
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
            return "field " + fieldName + " defined in blueprint needs to be present in value";
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
    array: verifier("value needs to be an array", function(n) {
      return n instanceof Array;
    }),
    nullable: function(verifier) {
      return function(n) {
        return n === null || verifier(n);
      };
    },
    undefinable: function(verifier) {
      return function(n) {
        return n === void 0 || verifier(n);
      };
    },
    equal: (function(x) {
      return module.exports.verifier("value needs to equal " + x, (function(n) {
        return n === x;
      }));
    }),
    "function": verifier("value needs to be a function", function(n) {
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
      return module.exports(either(verifiers));
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
        var s, _i, _len;
        for (_i = 0, _len = verifiers.length; _i < _len; _i++) {
          verifier = verifiers[_i];
          s = verifier(n);
          if (s !== true) {
            return s;
          }
        }
        return true;
      };
    },
    verifier: verifier
  };

}).call(this);
