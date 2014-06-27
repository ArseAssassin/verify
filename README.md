verify
======

> We don't need no undefinition

## What is verify?

Verify is a JavaScript library designed to solve the `undefined` problem.

> > f = (a) -> a + 2
> > f(undefined)
> NaN

Since JavaScript allows you to access any property of any object returning `undefined` instead of throwing an error, it's easy to propagate undefined values through your program, where they cause problems after losing your stack trace. Verify counters this by allowing you to define your function signature:

> > f = from v.num, to v.num, (a) -> a + 2
> > f(undefined)
> Verifier error: Error verifying return value
