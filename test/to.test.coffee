assert = require "assert"

to = require "../src/to"

describe "to", ->
  it "should throw error on invalid return value", ->
    f = to (-> false), ->

    assert.throws f

  it "should not throw error on valid return value", ->
    f = to (-> true), ->

    f()
