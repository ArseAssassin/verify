assert = require "assert"

verifiers = require "../src/verifiers"

describe "verifiers", ->
  describe "object", ->
    it "shouldn't accept null", ->
      assert.equal verifiers.object(null), "value needs to be an object"

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
      assert.equal a([3, 4, 5]), "array verification needs to pass on value 4: false"

    it "should not accept non-arrays", ->
      a = verifiers.arrayOf (x) -> x == 3
      assert.equal a({}), "value needs to be an array"

  describe "equal", ->
    it "should accept identical values", ->
      f = verifiers.equal 3
      assert f 3
      assert.equal f(2), "value needs to equal 3"

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

      assert.equal a(
        a: 1
        b: 2
        c: 5
      ), "blueprint verification needs to pass on field c: false"

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

      assert.equal a(
        a:
          a: 4
          b: 2
        b: 3
      ), "blueprint verification needs to pass on field a: blueprint verification needs to pass on field a: false"

    it "should fail on extra fields", ->
      a = verifiers.blueprint
        a:
          a: (x) -> x == 1

      assert.equal a(
        a:
          a: 1
        b: 2), "field b defined in blueprint needs to be present in value"

    describe "partial", ->
      it "should not fail on missing fields", ->
        a = verifiers.blueprint
          a: (x) -> x == 1
          b: (x) -> x == 1

        assert verifiers.partial(a)
          a: 1

        assert.equal verifiers.partial(a)(
          a: 2), "blueprint verification needs to pass on field a: false"




