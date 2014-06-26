module.exports.from = require "./from"
module.exports.to = require "./to"
module.exports.verifiers = require "./verifiers"

reporter = (s) ->
  console.log("Verifier error: #{s}")
  console.log(new Error().stack)

module.exports.setReporter = (x) -> reporter x
module.exports.getReporter = -> reporter
