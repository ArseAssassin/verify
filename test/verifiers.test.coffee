verifiers = require "../src/verifiers"

assert = require "assert"

main = require "../src/main"

verifies = (x) ->
  assert.equal true, x

errors = (error, x) ->
  assert.equal error, x

describe "verifiers", ->
  describe "object", ->
    it "shouldn't accept null", ->
      errors "needs to be an object", verifiers.object(null)

    it "should accept object", ->
      verifies verifiers.object({})

  describe "num", ->
    it "should accept numbers", ->
      verifies verifiers.num(2)

  describe "bool", ->
    it "should accept false", ->
      verifies verifiers.bool(false)

    it "should accept true", ->
      verifies verifiers.bool(true)

    it "should not accept anything else", ->
      errors "needs to be a boolean", verifiers.bool(null)

  describe "string", ->
    it "should accept string", ->
      verifies verifiers.string("")

    it "should not accept undefined or null", ->
      errors "needs to be a string", verifiers.string(undefined)
      errors "needs to be a string", verifiers.string(null)

  describe "nullable", ->
    it "should accept null", ->
      verifies verifiers.nullable(-> false)(null)

    it "should accept secondary verifier", ->
      verifies verifiers.nullable((x) -> x == true)(true)

  describe "undefinable", ->
    it "should accept undefined", ->
      verifies verifiers.undefinable(-> false)(undefined)

    it "should accept secondary verifier", ->
      verifies verifiers.undefinable((x) -> x == true)(true)

  describe "enum", ->
    f = verifiers.enum("cat", "dog", "guy")

    it "should accept any of the arguments", ->
      for x in ["cat", "dog", "guy"]
        verifies f(x)

    it "should reject anything not in the arguments", ->
      assert.equal f("car"), "needs to equal cat or needs to equal dog or needs to equal guy"

  describe "either", ->
    f = verifiers.either(((x) -> x == 2), ((x) -> x == 3))
    it "should accept any of the argument functions", ->
      verifies f(2)
      verifies f(3)

    it "should reject anything not in the argument functions", ->
      assert.equal f(4), "false or false"

  describe "and", ->
    f = verifiers.and(((x) -> x > 10), ((x) -> x < 20))

    it "should accept values that pass all checks", ->
      verifies f(15)

    it "should not accept values that fail any checks", ->
      assert.equal f(7),  "false and true"
      assert.equal f(27), "true and false"

  describe "array", ->
    it "should accept empty arrays", ->
      verifies verifiers.array([])

  describe "arrayOf", ->
    it "should accept valid arrays", ->
      a = verifiers.arrayOf (x) -> x == 3
      verifies a [3, 3, 3]
      assert.equal a([3, 4, 5]), "array verification needs to pass on 4: false"

    it "should report error on invalid verifier", ->
      report = ""

      oldReporter = main.getReporter()

      main.setReporter (x) ->
        report = x

      verifiers.arrayOf null

      assert.equal report, "Invalid verifier for arrayOf: null"

      main.setReporter oldReporter

    it "should not accept non-arrays", ->
      a = verifiers.arrayOf (x) -> x == 3
      assert.equal a({}), "needs to be an array"

  describe "equal", ->
    it "should accept identical values", ->
      f = verifiers.equal 3
      verifies f 3
      assert.equal f(2), "needs to equal 3"

  describe "blueprint", ->
    it "should fail if any matcher fails", ->
      a = verifiers.blueprint 
        a: (x) -> x == 1
        b: (x) -> x == 2
        c: (x) -> x == 3

      verifies a
        a: 1
        b: 2
        c: 3

      errors "blueprint verification needs to pass on field c: false", a(
        a: 1
        b: 2
        c: 5
      )

    it "should handle nested properties", ->
      a = verifiers.blueprint
        a:
          a: (x) -> x == 1
          b: (x) -> x == 2
        b: (x) -> x == 3

      verifies a
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
        b: 2), "field b present in value, but not in blueprint"

    describe "partial", ->
      it "should not fail on missing fields", ->
        a = verifiers.blueprint
          a: (x) -> x == 1
          b: (x) -> x == 1

        verifies verifiers.partial(a)
          a: 1

        assert.equal verifiers.partial(a)(
          a: 2), "blueprint verification needs to pass on field a: false"

      it "should not fail on nested missing fields", ->
        a = verifiers.blueprint
          a: 
            a: (x) -> x == 1
            b: (x) -> x == 1

        verifies verifiers.partial(a)
          a:
            a: 1

