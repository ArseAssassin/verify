main = require "./main"

module.exports = (verifier , f) ->
  name = "anonymous"

  if f != null && f != undefined && f.name
    name = f.name

  if !verifier
    main.getReporter()("Error setting up return value of function #{name}: verifier is #{verifier}")
  if !f
    main.getReporter()("Error setting up return value: function is #{f}")
  ->
    fArgs = Array.prototype.slice.call arguments

    r = f.apply this, fArgs

    s = verifier r
    if s != true
      main.getReporter()("Error verifying return value of function #{name}: #{s}")

    r

