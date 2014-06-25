assert = require "assert"

verifiers = require "../src/verifiers"

describe "verifiers", ->
  describe "object", ->
    it "shouldn't accept null", ->
      assert.equal verifiers.object(null), false

    it "should accept object", ->
      assert verifiers.object({})

  describe "num", ->
    it "should accept numbers", ->
      assert verifiers.num(2)

  describe "string", ->
    it "should accept string", ->
      assert verifiers.string("")

  describe "nullable", ->
    it "should accept null", ->
      assert verifiers.nullable(-> false)(null)

    it "should accept secondary verifier", ->
      assert verifiers.nullable((x) -> x == true)(true)

  describe "undefinable", ->
    it "should accept undefined", ->
      assert verifiers.undefinable(-> false)(undefined)

    it "should accept secondary verifier", ->
      assert verifiers.undefinable((x) -> x == true)(true)


  describe "array", ->
    it "should accept empty arrays", ->
      assert verifiers.array([])

  describe "arrayOf", ->
    it "should accept valid arrays", ->
      a = verifiers.arrayOf (x) -> x == 3
      assert a [3, 3, 3]
      assert !a [3, 4, 5]

    it "should not accept non-arrays", ->
      a = verifiers.arrayOf (x) -> x == 3
      assert !a {}

  describe "equals", ->
    it "should accept identical values", ->
      f = verifiers.equal 3
      assert f 3
      assert !f 2

  describe "blueprint", ->
    it "should fail if any matcher fails", ->
      a = verifiers.blueprint 
        a: (x) -> x == 1
        b: (x) -> x == 2
        c: (x) -> x == 3

      assert a,
        a: 1
        b: 2
        c: 3

      assert !a
        a: 1
        b: 2
        c: 5

    it "should handle nested properties", ->
      a = verifiers.blueprint
        a:
          a: (x) -> x == 1
          b: (x) -> x == 2
        b: (x) -> x == 3

      assert a
        a:
          a: 1
          b: 2
        b: 3

      assert !a
        a:
          a: 4
          b: 2
        b: 3

    it "should fail on extra fields", ->
      a = verifiers.blueprint
        a:
          a: (x) -> x == 1

      assert.throws -> a
        a:
          a: 1
        b: 2

    describe "partial", ->
      it "should not fail on missing fields", ->
        a = verifiers.blueprint
          a: (x) -> x == 1
          b: (x) -> x == 1

        assert verifiers.partial(a)
          a: 1

        assert !verifiers.partial(a)
          a: 2




