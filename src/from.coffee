helpers = require "./helpers"

main = require "./main"

module.exports = ->
  args = Array.prototype.slice.call arguments

  f = args[args.length-1]
  argumentNames = helpers.parseFunctionArguments f
  validators = args.splice(0, args.length-1)

  for validator in validators
    if !validator
      throw new Error "Invalid validator #{validator}"

  ->
    fArgs = Array.prototype.slice.call arguments

    for k, v of fArgs
      s = validators[k](v)
      if s != true
        main.getReporter()("Validation error in argument #{arguments[k]}, #{v}: #{s}")

    f.apply(this, fArgs)

