+++
title = "Measure Theory"
tags = ["notes", "math", "analysis"]
date = Date(2022, 11, 13)
firstdraft = Date(2022, 11, 13)
lastupdate = Date(2022, 11, 13)
+++

# {{ title }}

{{page_tags}}


<!-- For the honors exam I took back in my senior year of college, we were -->
<!-- supposed to have learned up to the end of chapter 2 of this book. Yet no -->
<!-- questions were asked on Lebesgue theory! So I'm going to try to plow -->
<!-- through a little more of this book. My main question-marks walking into -->
<!-- this are: -->

<!-- 1.  Where does the notion of measure come into play with respect to -->
<!--     differentiation? -->
<!-- 2.  Will the fundamental theorem of calculus still hold in this more -->
<!--     abstract setting? -->
<!-- 3.  How will the Lebesuge measure guide us to formulating a more -->
<!--     abstract notion of "volume"? (thinking towards these abstract -->
<!--     measure spaces) -->
<!-- 4.  What's a fractal, and how do you mathematically detect one? -->


Recently (2023-01-16), I've taken an interest in measure-theoretic
probability. I haven't learned probability formally, but in the
process of working through Mackay's *Information Theory, Inference,
and Learning Algorithms*, I've built up many unanswered questions. How
is mutual information defined on more abstract measure spaces? Or
KL-Divergence? Even seemingly benign issues like "defining a
conditional probability" is not so simple.  Presumably this all
underpins statistical manifolds and information geometry, which sounds
like a lot of fun.

The journey to having a strong foundation in probability is a long
one. One piece of this journey is measure theory, which will also be
helpful in the study of Hilbert spaces. Someday I may even have an
idea as to what Reproducing Kernel Hilbert Spaces are really about,
since everyone's been talking about them since the 70's in the machine
learning literature.

Books I'm using right now:
- [S&S] Stein & Shakarchi; Book 3: Measure Theory, Integration, &
  Hilbert Spaces
- [R] Royden; Real Analysis
  - need this one for the Radon-Nikodym derivative, which is what
    gives you probability densities from a CDF or more general
    probability measure.

\toc 

## Outer Measures. The Lebesgue Measure
### S&S P1.3 -- Cantor Sets of Constant Dissection 

\problem{
Consider the unit interval $[0,1]$ and let $0 < \xi < 1$.
($\xi = \frac{1}{3}$ will give the cantor set).

In stage 1 of the construction, remove the centrally situated open
interval in $[0,1]$ of length $\xi$. In stage 2, remove *two*
central intervals each of relative length $\xi$, one in each of the
remaining intervals after stage 1, and so on.

Let $\mathcal{C}_{\xi}$ denote the set which remains after
applying the above indefinitely.

1. Prove that the complement of $C_{\xi}$ is the union of open
    intervals of total length equal to 1.
2. Show directly that $m_{*}(C_{\xi}) = 0$.}{
1.  First, $C_{\xi}$ is closed since it is the (arbitrary) intersection of closed sets: $C_{\xi} = \cap_{0}^{\infty}C_{k}$, where $C_{k}$ denotes the remaining points of $[0,1]$ after the $k^{th}$ iteration of our algorithm. To see that each $C_{k}$ is closed:

-   $C_{0}$ is closed ($[0,1]$).
-   Let $C_{k-1}$ be closed with remaining length $(1 -
    \xi)^{k-1}$. First, $C_{k} = C_{k-1} - \mathcal{O}$,
    where $\mathcal{O}$ is the set of $k-1$ central open
    intervals of $C_{k-1}$ of relative length $\xi$. Then
    $C_{k}$ is closed as $C_{k}^{c} = C_{k-1}^{c} \cup
    \mathcal{O}$ is open. Unforunately induction saves the day.

Now for the length issue. This seems like a grind to get the interval
lengths adding up to the form of $(1-\xi)^{k}$. This seems reasonable,
right? On the first iteration, we have $1-\xi$ length.  On the next,
we have $(1-\xi) - \xi\cdot(1 - \xi) = 1 - 2\xi + \xi^{2} =
(1-\xi)^{2}$. On the $(k+1)^{th}$ iteration we have $(1-\xi)^{k} -
\xi\cdot(1 - \xi)^{k} = (1-\xi)(1 - \xi)^{k} = (1-\xi)^{k+1}$. Very convenient.

Then as $k \to \infty$, $(1 - \xi)^{k} \to 0$ if $\xi < 1$. Therefore
$_{}C_{\xi}^{c} \rightarrow 1$ as desired. We obtain this by applying
Theorem 3.2 ($m_{*}(C_{\xi}) + m_{*}(C_{\xi}^{c}) = 1$), which is
allowed since open and closed sets are measurable.

2. First note, as before, that $C_{\xi} = \cap_{k=0}^{\infty}C_{k}$,
   where we have that $C_{k} \subset C_{k-1}$ for all $k$. Then by
   monotonicity, $m_{*}(C_{\xi}) \leq m_{*}(C_{k})$ for all $k$. But
   from the previous part, $m_{*}(C_{k}) = (1 - \xi)^{k}$. Therefore
   $m_{*}(C_{\xi}) \leq (1-\xi)^{k}$ for all $k,$ and so
   $m_{*}(C_{\xi}) = 0$.}

*Commentary*: This problem is actually (for me) one of those
intuition-breaking problems. Choose *any* $\xi < 0$ then if you cut
out intervals of relative length $\xi$ from $[0,1]$, you'll end up
with a measure zero set no matter what! Imagine choosing $\xi =
0.000001$ and initially cutting out the subset $(0.4999995,
0.5000005)$. Would you think if you iterate on this you end up with
"essentially nothing"? Dust? Infinity is powerful.

In some way, this is telling us that the successive powers of two,
cutting each sub-interval into *two* pieces is enough to kill the
whole set, so long as this cut leaves some space between the slices.
Eventually, each slice gets cut up enough so that it turns to
dust. The intuition comes back if you look at the evolution of the
first interval: $[0, (1-\xi)/2] \to [0, (1-\xi)^{2}/2^{2}] \to \cdots
\to [0, (1-\xi)^{k}/2^{k}]$. We can already see this set being crushed
at the edge, not only because $(1-\xi)^{k}$ will crush itself, but
$1/2^{k} \to 0$ as well! There may be a way to balance this ratio
$(1-\xi)^k/2^k$ to get a non-zero measure at the edges. I think these
are known as "fat Cantor sets", which are detailed in the next problem. 