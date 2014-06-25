module.exports = 
  num: (n) -> typeof n == "number"
  string: (n) -> typeof n == "string"
  object: (n) -> n != null && typeof n == "object"
  arrayOf: (verifier) -> (n) -> 
    if !module.exports.array(n)
      false
    else
      for x in n
        if !verifier(x)
          return false

      true

  blueprint: (base) ->
    for field, verifier of base
      if typeof verifier == "object"
        base[field] = module.exports.blueprint(verifier)
      else if typeof verifier != "function"
        throw new Error("Invalid verifier for field #{field}: #{verifier}")
    (n, secondary_matcher=null) ->
      for field, verifier of base
        value = n[field]
        if secondary_matcher 
          if !secondary_matcher(verifier)(value)
            return false
        else if !verifier(value)
          return false

      for fieldName, fieldValue of n
        if !base[fieldName]
          throw new Error("Field #{fieldName} defined in argument but not in blueprint")

      true

  partial: (blueprint) -> (n) -> blueprint(n, module.exports.undefinable)
  array: (n) -> n instanceof Array

  nullable:     (verifier) -> (n) -> n == null      || verifier(n)
  undefinable:  (verifier) -> (n) -> n == undefined || verifier(n)

  equal: (x) -> (n) -> n == x

  function: (n) -> typeof n == "function"
