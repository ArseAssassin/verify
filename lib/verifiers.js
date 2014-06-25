(function() {
  module.exports = {
    num: function(n) {
      return typeof n === "number";
    },
    string: function(n) {
      return typeof n === "string";
    },
    object: function(n) {
      return n !== null && typeof n === "object";
    },
    arrayOf: function(verifier) {
      return function(n) {
        var x, _i, _len;
        if (!module.exports.array(n)) {
          return false;
        } else {
          for (_i = 0, _len = n.length; _i < _len; _i++) {
            x = n[_i];
            if (!verifier(x)) {
              return false;
            }
          }
          return true;
        }
      };
    },
    blueprint: function(base) {
      var field, verifier;
      for (field in base) {
        verifier = base[field];
        if (typeof verifier === "object") {
          base[field] = module.exports.blueprint(verifier);
        } else if (typeof verifier !== "function") {
          throw new Error("Invalid verifier for field " + field + ": " + verifier);
        }
      }
      return function(n, secondary_matcher) {
        var fieldName, fieldValue, value;
        if (secondary_matcher == null) {
          secondary_matcher = null;
        }
        for (field in base) {
          verifier = base[field];
          value = n[field];
          if (secondary_matcher) {
            if (!secondary_matcher(verifier)(value)) {
              return false;
            }
          } else if (!verifier(value)) {
            return false;
          }
        }
        for (fieldName in n) {
          fieldValue = n[fieldName];
          if (!base[fieldName]) {
            throw new Error("Field " + fieldName + " defined in argument but not in blueprint");
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
    array: function(n) {
      return n instanceof Array;
    },
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
    equal: function(x) {
      return function(n) {
        return n === x;
      };
    },
    "function": function(n) {
      return typeof n === "function";
    }
  };

}).call(this);
