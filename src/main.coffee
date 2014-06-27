module.exports.from = require "./from"
module.exports.to = require "./to"
module.exports.verifiers = require "./verifiers"

reporter = (s) ->
  console.warn("Verifier error: #{s}")
  stack = new Error().stack

  l = stack.split("\n")
  newL = []
  for x in l
    if x.indexOf("/node_modules/verify/") == -1 && x.indexOf("Error:") != 0
      newL.push x

  console.warn(newL.join("\n"))

module.exports.setReporter = (x) -> reporter = x
module.exports.getReporter = -> reporter
