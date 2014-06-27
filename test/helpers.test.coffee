assert = require "assert"

helpers = require "../src/helpers"

describe "parseFunctionArguments", ->
  it "should parse argument names", ->
    assert.equal helpers.parseFunctionArguments((a, b, c) ->).join(","), "a,b,c"
    assert.equal helpers.parseFunctionArguments(->).join(","), ""

    
