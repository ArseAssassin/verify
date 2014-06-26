verifier = (error, f) -> (n) -> 
  if f(n) == false
    error
  else
    true


module.exports = 
  num: verifier "value needs to be a number", (n) -> typeof n == "number"
  string: verifier "value needs to be a string", (n) -> typeof n == "string"
  object: verifier "value needs to be an object", (n) -> n != null && typeof n == "object"
  arrayOf: (verifier) -> (n) -> 
    s = module.exports.array(n)
    if s != true
      s
    else
      for x in n
        s = verifier(x)
        if s != true
          return "array verification needs to pass on value #{x}: #{s}"

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
          s = secondary_matcher(verifier)(value)
          if s != true
            return "blueprint verification needs to pass on field #{field}: #{s}"
        else 
          s = verifier(value)
          if s != true
            return "blueprint verification needs to pass on field #{field}: #{s}"

      for fieldName, fieldValue of n
        if !base[fieldName]
          return "field #{fieldName} defined in blueprint needs to be present in value"

      true

  partial: (blueprint) -> (n) -> blueprint(n, module.exports.undefinable)
  array: verifier "value needs to be an array", (n) -> n instanceof Array

  nullable:     (verifier) -> (n) -> n == null      || verifier(n)
  undefinable:  (verifier) -> (n) -> n == undefined || verifier(n)

  equal: ((x) -> module.exports.verifier("value needs to equal #{x}", ((n) -> n == x)))

  function: verifier "value needs to be a function", (n) -> typeof n == "function"

  enum: ->
    verifiers = []
    for value in Array.prototype.slice.call arguments
      verifiers.push module.exports.equal value

    module.exports either(verifiers)

  either: -> 
    verifiers = Array.prototype.slice.call arguments
    (n) ->
      l = []
      for verifier in verifiers
        s = verifier n
        l.push s

      if l.indexOf(true) > -1
        true
      else
        l.join(" or ")

  and: ->
    verifiers = Array.prototype.slice.call arguments
    (n) ->
      for verifier in verifiers
        s = verifier n
        if s != true
          return s

      true

  verifier: verifier
