+++
title = "Monadic Parsing in Scheme"
tags = ["cs", "lisp"]
date = Date(2022, 11, 22)
hascode = true
+++

# {{title}}
{{page_tags}}

The below is a formulation of monadic parsing in a lisp-like programming
environment, where function composition and recursion are especially
accommodated. To see a barebones implementation of such a monadic
parsing library in scheme, check out my library:
[parmesan](https://github.com/LiamPack/parmesan).

**2022-11-22**: For now, the below post is directly from the README of
parmesan, but I plan to add more context and intuition in the
future. The parsing construct is actually more general than just string
parsing -- it generalizes to generic stream parsing, so long as the data
type is known ahead of time.

\toc

## What is a Parser?
A parser is a lambda with three arguments:

```scheme
(define some-parser/p (lambda (s ks kf) ...))
```

Where `s` is the current string to parse, `ks` is a function to call on
successfully parsing `s`, and `kf` is a function to call if parsing
fails. `ks` is assumed to be a lambda of two arguments; a function of
the parsed value and the rest of the string to parse `ks := (lambda (v
s2) ...)`. Note that `ks` has no other restrictions. It can be
interpreted as a parser that is parameterized by `v` and the captured
`kf` in the enclosing scope if its declared inline. If its passed, then
it can itself have a captured parser to operate on `s1`. `kf` is assumed
to be a thunk `(lambda () ...)`. It can itself contain captured
information, so the type is less restrictive than it initially seems.

The lambda structure lends naturally to some simple parsers. For
example, the a parser which checks that the head of `s` matches a
predicate:

```scheme
(define (psym pred)
  (lambda (s ks kf)
    (if (null? s)
        (kf)
        (if (pred (car s))
            (ks (car s) (cdr s))
            (kf)))))
```

In words: If `car s` matches our predicate, say `(lambda (c) (eq? (car
s) c))`, then we can call our success function on `(car s)` and `(cdr
s)`. Otherwise, we the parse failed.


## Demonstrating the Monadic structure

We can impose monadic rules on the structure by defining the
prototypical `return`, `fail`, and `bind` operators:

```scheme
(define (return v) (lambda (s ks kf) (ks v s)))
(define fail (lambda (s ks kf) (kf)))
(define empty/p (return '()))

;; >>=
(define (bind a f)
  (lambda (s ks kf)
    (a s
       (lambda (av s1) ((f av) s1 ks kf))
       kf)))
```

`return` is clear: immediately succeed on the passed value `v` with the
success function while not parsing any of `s`. A "no-op" parser, or an
empty parser `empty/p`, is represented by `(return '())`. `fail`
immediately calls the failure function.

`bind` fits naturally into the schema: Use `a` as a parser, and then
lift its return value `av` with `(f av)`, producing another parser, and
then parse the remaining string `s1`: `((f av) s1 ks kf)`. In this case,
`f` is assumed to be a `(lambda (v) (lambda (s ks kf) ...))`, i.e a
parser parameterized by `v`.

I'll also throw in a `(lift a f)`, which is probably non-standard
naming, to represent the operation of `compose a with (return (f
x))`. In this case, instead of `f` being of type `f: t -> t parser`, we have
`f: t -> t` and need to lift its result with `return`:

```scheme
(define (lift a f)
  (bind a (lambda (x) (return (f x)))))
```

## Combinators

We can write an `(either/p a b)`, which first tries parser `a`
on the input, then parser `b`, and uses the first which succeeds, as
well as `(and/p a b)`, which runs `a`, then `b`, and combines their
results into a list:

```scheme
(define (either/p a b)
  (lambda (s ks kf)
    (a s ks
       (lambda () (b s ks kf)))))

(define (and/p a b)
  (lambda (s ks kf)
    (a s
       (lambda (av s1)
         (b s1
            (lambda (bv s2) (ks (cons av bv) s2))
            kf))
       kf)))
```

`bind`, `either/p`, and `and/p` give us the composability we need to
write combinators. For example, to run a list of parsers `as`, we can
create the combinator `all-of/p` by folding with `and/p`:

```scheme
(define (all-of/p . as)
  (fold-right and/p empty/p as))
```

Likewise, we can also lift a parser `p` by running it as many times as
it will allow on the input. In type terms, if `p` is a `t` parser, we
can create a combinator `many/p` which allows you to lift `p` to become
a `t list` parser `(many/p p)`:

```scheme
(define (many/p p)
  (either/p
   (bind
    p (lambda (pv)
        (lift (many/p p) (lambda (pvs) (cons pv pvs)))))
   empty/p))
```

Finally, we can write the `(repeat n p)` combinator, which runs `p` `n`
successive times on the input and produces a list of results:

```scheme
(define (repeat n p)
  (define (helper n1)
    (either/p
     (bind
      p (lambda (pv)
          (if (<= n1 0)
              fail
              (lift (helper (- n1 1))
                    (lambda (pvs) (cons pv pvs))))))
     empty/p))
  (helper n))
```