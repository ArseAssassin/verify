helpers = require "./helpers"

main = require "./main"

module.exports = ->
  args = Array.prototype.slice.call arguments

  getArgument = (index) ->
    argumentNames[index] || index

  f = args[args.length-1]

  if !f || !f.apply
    main.getReporter()("Invalid function to verify: #{f}")

  argumentNames = helpers.parseFunctionArguments f
  validators = args.splice(0, args.length-1)

  for k, validator of validators
    if !validator
      main.getReporter()("Invalid verifier for argument #{getArgument(k)}: #{validator}")

  ->
    fArgs = Array.prototype.slice.call arguments

    for k, validator of validators
      v = fArgs[k]
      s = validator(v)
      if s != true
        main.getReporter()("Verification error in argument #{getArgument(k)}, #{v}: #{s}")

    f.apply(this, fArgs)

