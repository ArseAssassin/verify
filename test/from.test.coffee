assert = require "assert"

from = require "../src/from"
main = require "../src/main"

oldReporter = main.getReporter()

lt = (x) -> (n) -> n < x

describe "from", ->
  report = ""

  beforeEach ->
    report = ""
    main.setReporter (x) ->
      report = x

  afterEach ->
    main.setReporter oldReporter

  f = from lt(10), lt(7), lt(5), (a, b ,c) ->
    a+b+c

  it "should call verifiers for each argument", ->
    assert.equal f(1, 1, 1), 3

  it "should report the first unverified argument", ->
    f(15, 4, 2)

    assert.equal report, "Verification error in argument a, 15: false"

    f(7, 10, 2)

    assert.equal report, "Verification error in argument b, 10: false"

    f(2, 4, 10)

    assert.equal report, "Verification error in argument c, 10: false"

    assert.equal f(2, 2, 2), 6

  it "should report when function called with too few arguments", ->
    f()

    assert.equal report, "Verification error in argument c, undefined: false"