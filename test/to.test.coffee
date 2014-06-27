assert = require "assert"

to = require "../src/to"
main = require "../src/main"

oldReporter = main.getReporter()

describe "to", ->
  report = ""
  beforeEach ->
    report = ""
    main.setReporter((x) ->
      report = x)

  afterEach ->
    main.setReporter oldReporter

  it "should throw error on invalid return value", ->
    f = to (-> false), ->

    f()

    assert.equal report, "Error verifying return value of function anonymous: false"

  it "should not report error on valid return value", ->
    f = to (-> true), ->

    f()

    assert.equal report, ""

  it "should report error on invalid verifier", ->
    f = to null, ->

    assert.equal report, "Error setting up return value of function anonymous: verifier is null"

  it "should report error on invalid function", ->
    f = to (-> true), null

    assert.equal report, "Error setting up return value: function is null"