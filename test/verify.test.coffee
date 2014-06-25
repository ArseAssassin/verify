assert = require "assert"

verify = require "../src/verify"

lt = (x) -> (n) -> n < x


describe "verify", ->
  f = verify lt(10), lt(7), lt(5), (a, b ,c) ->
    a+b+c

  it "should call verifiers for each argument", ->
    assert.equal f(1, 1, 1), 3

  it "should fail on first unverified argument", ->
    assert.throws (->
      f(15, 4, 2)
    )

    assert.throws (->
      f(7, 10, 2)
    )

    assert.throws (->
      f(2, 4, 10)
    )

    assert.equal f(2, 2, 2), 6