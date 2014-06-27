main = require "./main"

verifier = (error, f) -> (n) -> 
  if f(n) == false
    error
  else
    true


module.exports = 
  num: verifier "needs to be a number", (n) -> typeof n == "number"
  string: verifier "needs to be a string", (n) -> typeof n == "string"
  object: verifier "needs to be an object", (n) -> n != null && typeof n == "object"
  bool: verifier "needs to be a boolean", (n) -> typeof n == "boolean"
  arrayOf: (verifier) -> 
    if !verifier
      main.getReporter()("Invalid verifier for arrayOf: #{verifier}")
    (n) -> 
      s = module.exports.array(n)
      if s != true
        s
      else
        for x in n
          s = verifier(x)
          if s != true
            return "array verification needs to pass on #{x}: #{s}"

        true

  blueprint: (base) ->
    for field, verifier of base
      if typeof verifier == "object"
        base[field] = module.exports.blueprint(verifier)
      else if typeof verifier != "function"
        main.getReporter()("Invalid verifier for field #{field}: #{verifier}")
    (n, secondary_matcher=null) ->
      for field, verifier of base
        value = n[field]
        if secondary_matcher != null
          s = secondary_matcher(verifier)(value, secondary_matcher)
          if s != true
            return "blueprint verification needs to pass on field #{field}: #{s}"
        else 
          s = verifier(value)
          if s != true
            return "blueprint verification needs to pass on field #{field}: #{s}"

      for fieldName, fieldValue of n
        if !base[fieldName]
          return "field #{fieldName} present in value, but not in blueprint"

      true

  partial: (blueprint) -> (n) -> blueprint(n, module.exports.undefinable)
  array: verifier "needs to be an array", (n) -> n instanceof Array

  nullable:     (verifier) -> (n, secondary_matcher=null) -> n == null      || verifier(n, secondary_matcher)
  undefinable:  (verifier) -> (n, secondary_matcher=null) -> n == undefined || verifier(n, secondary_matcher)

  equal: ((x) -> module.exports.verifier("needs to equal #{x}", ((n) -> n == x)))

  function: verifier "needs to be a function", (n) -> typeof n == "function"

  enum: ->
    verifiers = []
    for value in Array.prototype.slice.call arguments
      verifiers.push(module.exports.equal value)

    module.exports.either.apply(this, verifiers)

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
      l = []
      for verifier in verifiers
        l.push verifier n

      for value in l
        if value != true
          return l.join(" and ")
      true

  verifier: verifier
