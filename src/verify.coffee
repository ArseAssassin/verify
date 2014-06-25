module.exports = ->
  args = Array.prototype.slice.call arguments

  f = args[args.length-1]
  validators = args.splice(0, args.length-1)

  for validator in validators
    if !validator
      throw new Error "Invalid validator #{validator}"

  ->
    fArgs = Array.prototype.slice.call arguments

    for k, v of fArgs
      if !validators[k](v)
        console.log "Validation error in object", v
        throw new Error("Validation error: argument #{k} #{v}")

    f.apply(null, fArgs)

