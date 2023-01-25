+++
title = "Algebra; Artin"
tags = ["notes", "math", "algebra"]
date = Date(2023, 01, 16)
firstdraft = Date(2023, 01, 16)
lastupdate = Date(2022, 11, 22)
+++

# {{ title }}

{{page_tags}}

*last updated: {{lastupdate}}*

Algebra is the backbone of mathematical description, and
(finite-dimensional) linear algebra is possibly the most important
tool in the tool-belt: whats better than turning a complicated problem
into a problem of counting dimension?

Problems and commentary will be pulling from:
- Artin's *Algebra*
- Halmos's *Finite-Dimensional Vector Spaces*

While Artin prioritizes computations and intuition from choosing a
basis (an isomorphism to a column vector space \(F^n\)), Halmos
focuses on remaining in the abstract language of linear maps (no
choice of isomorphism to coordinates in \(F^n\)). 

Both approaches have advantages: Artin's computational approach pays
dividends in later chapters when the matrix exponential comes to the
forefront, allowing e.g. Jordan canonical forms to shine, which then
comes back in the discussion of compact topological groups, Lie
algebras, and Lie groups. Also concrete symmetries of the plane.

Halmos's approach has the advantage of using language and techniques
consistent with the fields of functional analysis and Hilbert space
theory, where the primary difference is that your underlying vector
space may be infinite-dimensional.

\toc

## Some Thoughts on Coordinates and Bases
### What is a Basis
*Basis* is a term that actually pops up relatively frequently in
mathematics. The least committal description I can come up with is:
a *basis* is a bag of elements which, when you mix them according to
some operation, you can generate any element you want. In linear
algebra, this means taking linear combinations of vectors; in
topology, this means taking countable unions and finite intersections
of open sets; in measure theory, this means taking countable unions
and intersections of measurable sets; and so forth.

What's important about a basis is that, once you've chosen a
particular basis (some call this "using up your degree of freedom," or
"expending your choice"), you can start computing in a more natural
way: If you write your basis of a vector space \(V\) as a tuple of
vectors, \((v_1, \cdots, v_n)\), there is a natural map \(\mathbf{B}:
F^n -> V\) which sends \(X \to \mathbf{B}X\) , where \(\mathbf{B}\) is
the matrix whose columns consist of the basis elements \(v_1 \cdots
v_n\). Now you can do whatever computation you'd like "row-wise" with
the field \(F\), and since the basis defines an isomorphism, any
results you find will hold in the general case.

This operation is especially powerful (and very frequent!) in
something like general relativity. You may have seen Einstein's field
equations in their famous form (not including cosmological constant):

\[R_{\mu\nu} - \frac12 R g_{\mu\nu} \propto T_{\mu\nu}\]

This is great: you can compute the evolution of mass and gravity so
long as you know some initial conditions on the metric \(g_{\mu\nu}\)
and the stress-energy tensor \(T_{\mu\nu}\). A less commonly taught
form of the field equations (if you're in undergrad, or taking a first
grad course) is in "coordinate free" form:

\[\mathbf{G} \propto T\]

This form has advantages: there is a clarity in withholding a choice
of coordinates, since the meaning of indices isn't required to
understand the statement. So long as you're clear on the definition of
a tensor being a multilinear map on copies of \(V\) and \(V^*\), its a
difficult equation to forget (as opposed to index juggling). The
downside is, of course, you'll have a hard time calculating anything
until you pick a basis.

### An aside on the determinant
I've always found it interesting that Artin's *Algebra* starts off
batting with matrices and their properties. Lots of abstract algebra
textbooks start with set theory, category theory, or jump straight
into groups, but Artin has a broader plan.

Matrices end up a central tool of study for the topics that form a
large chunk of the content in this book: vector spaces over arbitrary
fields, symmetries of the plane, compact and differentiable groups,
representation theory, free modules, Galois theory, etc.

So a basis is almost always chosen in Artin; this isn't as bad as it
seems (unless you're a coordinate-free purist). While you cashed in a
choice at the price of more elements to juggle around, you gained a
concrete method for computing elementary operations and determinants,
and perhaps most importantly, you get to visualize whats happening.

In the second edition of Artin (which is the hard-copy I have),
there isn't much talk much about the geometric effects of a matrix on the
underlying $\R^n$ vector space. In the third edition, he finally adds
commentary on the meaning of the determinant, providing a key fact in
the understanding of matrices: *the determinant measures the expansion
or contraction of a unit-cube after its pushed through a matrix, with
sign indicating orientiation*. It doesn't get more important than
that --- this is a fact that, on my first encounter, I just took to be
a "cute" side effect of the definitions. But this fact extends far
further than the insulated study of matrices, and underlies one of my
favorite mathematical objects: the alternating tensors.

The alternating tensors give you volumes of projections. In more
words, if $\psi(v_1,\cdots,v_k)$ is an alternating tensor, then $\psi$
measures the resulting volume from adding up different projections of
the $k$-dimensional parallelopiped formed by $(v_1,\cdots,v_k)$. In
the case of $\psi(v_1,\cdots,v_k) = \det([v_1,\cdots,v_k])$, this
gives precisely the volume of the parallelopiped formed by the
inputted vectors.

Why would you care? For fun, suppose we're working in $\R^n$ and we
have an alternating $k$-tensor at every point in space, i.e. a family
$\{\psi_p\}_{p\in \R^n}$. Taking $n=3$ and $k=2$, this is analagous to
having a very *very* tiny parallelogram at every point in space marking
how much "k-volume" is being occupied. Why could this be useful?
Imagine you have a two-dimensional surface in $\R^3$ and you'd like to
know the surface area of the volume. In multivariable calculus, you
learn to take a funny integral that looks something like 

\[\int_S || \frac{\partial f}{\partial u} \times \frac{\partial
f}{\partial v}||du dv\]

which you're told is measuring the "surface area" at every local point
thanks to the cross-product. Abusing notation and making up math,
another way to write this would be to derive a tensor field $\psi_p$
at every point on the surface which would measure the local
deformation the surface applies to a unit square, and then add them
up: \[\int_S \psi_p\] where we've dropped the $dx$ type objects since
they're meaningless anyway. If there's a way to derive a tensor field
given a surface, and if there's a way to define an integral with
respect to these fields, then we can now integrate functions over
k-dimensional surfaces. 

All that to say: I think starting with matrices, understanding their
algebra, and building a geometric intuition for $\R^n$ is good. There
are other approaches to the material which are also good, but given
that this book will eventually turn to matrix groups like $SU(n)$,
and to be poetic, this seems like a good idea.

### Problems
#### Artin 1.1.13; Nilpotent Matrices
\problem{A square matrix $A$ is *nilpotent* if $A^k = 0$ for some $k >
0$. Prove that if $A$ is nilpotent, then $I+A$ is invertible. Do this
by finding its inverse.}{}
We're looking for the inverse, $(I + A)^{-1}$. Being very tricky and
taking a formal power series:

\[(I+A)^{-1} = 1 - A + A^2 - A^3 + \cdots \]

note that I have made no attempt to define what equals sign $=$ means
in this case, but I'm sure things will work out well; if we find an
inverse that works which is a finite sum, we don't have to justify the
convergence of the infinite series.

So we calculate. Since $A^k = 0$ for some $k>0$, then $A^n = 0$ for
all $ n \geq k$. Therefore we can heuristically see that \[(I+A)^{-1}
= \sum_{n=0}^{k-1} (-1)^n A^n,\]

where we define through analogy $A^0 = I$. Computing by hand, 

\begin{align}
(I+A)(I+A)^{-1} &= (I+A)\sum_{n=0}^{k-1}(-1)^n A^n\\
	&= \sum_{n=0}^{k-1}(-1)^n A^n + \sum_{n=0}^{k-1}(-1)^n A^{n+1}\\
	&= I + (-A + A) + (-A^2 + A^2) + \cdots + (-A^{k-1} + A^{k-1}) +
	A^k\\
	&= I
\end{align}

So our candidate inverse ended up working due to in-between terms
telescoping and the final $A^k$ term dying due to the nilpotent
property. Since $A$ and $I+A$ are square, this inverse is the unique
inverse and we're done.

*Commentary*: From what I can glean without looking into the future,
Artin put this problem here to give an appreciation for nilpotent
matrices (duh) since they'll come up later (oh! hey thats fun). In the
context of differential equations, a linear differential equation \[x'
= Ax\] admits very different structures depending on the structure of
$A$. The formal solution to such a differential equation takes the
form of $x(t) = \exp(At)x$, where $\exp(A)$ is defined as a formal
power series in $A$ and $x$ a vector of initial conditions.

When you plug in a nilpotent matrix into the power series, you end up
with a truncated series with all terms above $k$ dying off. There are
implications on the types of vector fields which can be generated by a
differential equation defined through a nilpotent matrix, so dusting
off some of this algebra was fun. To get a complete understanding of
their importance, we'll have to wait until Jordan forms, where pieces
of some "typical" nilpotent matrices are associated to generalized
eigenspaces with dimension \(\geq 2\), i.e., your linear operator has
non-distinct eigenvalues.

I first learned about this stuff in Hirsch and Smale's *Differential
Equations, Dynamical Systems, and Linear Algebra*, which is a much
older version of a book under a [very similar
name](https://www.amazon.com/Differential-Equations-Dynamical-Systems-Introduction/dp/0123820103). The
study of linear differential equations is central to the theory of
differential equations, since, as usual, a nonlinear equation \(x' =
f(x)\) reduces to a linear-type equation \(x' = Df(x_0)x\), so long as
you stay in a tight neighborhood of \(x_0\).
