//// COMPUTER SCIENCE
#let python(path) = raw(read(path), lang: "python", block: true)
#let pseudocode(c) = text(lang: "en", font: "New Computer Modern", dir: ltr)[#pseudocode-list(indentation-guide-stroke: .5pt + luma(180))[#c]]


//// MATH
// Formatting
#let QED = place(left, dy: -0.2cm, dx: -0.6cm, $qed$)
#let bar(x) = $overline(#x)$
#let tb(exp, top, bottom) = $attach(limits(#exp), b: #bottom, t: #top)$

// Logic
#let iff = $<=>$
#let iffd = $arrow.double.b.t$
#let arrr = $arrow.r.double$
#let arrl = $arrow.l.double$

// Set theory
#let seq = $subset.eq$
#let suq = $supset.eq$
#let uu = $union$
#let uud = $union.dot$
#let nn = $sect$
#let bs = $without$
#let ub = $union.big$
#let sb = $sect.big$
#let xx = $times$
#let symd = $triangle.t.stroked$
#let RNN = $RR^+_0$

// Linear algebra
#let char(f) = $"char"(#f)$

// Calculus
#let liminff(x) = $limits(lim)_(n->oo) #x$
#let limitn = $limits(lim)_(n->oo)$
#let limto(n) = $limits(lim)_(x->#n)$
#let limtoc(c, n) = $limits(lim)_(#c -> #n)$
#let suminf(a,k) = $sum_(#k=1)^oo #a _#k$
#let int(f) = $integral #f dif x$
#let intt(f, x) = $integral #f dif #x$

// Functions
#let of = $compose$
#let bv(f, s) = $#f bar.v_#s$
#let id(s) = $"id"_#s$
#let Id(s) = $"Id"_#s$
#let inv(f) = $#f^(-1)$
#let Im(f) = $"Im"(#f)$
#let dom(f) = $"dom"(#f)$

// General
#let pm = $plus.minus$
#let A1 = $A_1$
#let A2 = $A_2$
#let B1 = $B_1$
#let B2 = $B_2$
#let an = $a_n$
#let ank = $a_n_k$
