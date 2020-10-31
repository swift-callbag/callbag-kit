public func pipe<A, B>(
  _ b: @escaping (Producer<A>) -> B
) -> (@escaping Producer<A>) -> B {
  return { a in return b(a) }
}

public func pipe<A, B, C>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping (Producer<B>) -> C
) -> (@escaping Producer<A>) -> C {
  return { a in return c(b(a)) }
}

public func pipe<A, B, C, D>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping (Producer<C>) -> D
) -> (@escaping Producer<A>) -> D {
  return { a in return d(c(b(a))) }
}

public func pipe<A, B, C, D, E>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping (Producer<D>) -> E
) -> (@escaping Producer<A>) -> E {
  return { a in return e(d(c(b(a)))) }
}

public func pipe<A, B, C, D, E, F>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping (Producer<E>) -> F
) -> (@escaping Producer<A>) -> F {
  return { a in return f(e(d(c(b(a))))) }
}

public func pipe<A, B, C, D, E, F, G>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>,
  _ g: @escaping (Producer<F>) -> G
) -> (@escaping Producer<A>) -> G {
  return { a in return g(f(e(d(c(b(a)))))) }
}

public func pipe<A, B, C, D, E, F, G, H>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>,
  _ g: @escaping Operator<F, G>,
  _ h: @escaping (Producer<G>) -> H
) -> (@escaping Producer<A>) -> H {
  return { a in return h(g(f(e(d(c(b(a))))))) }
}

public func pipe<A, B, C, D, E, F, G, H, I>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>,
  _ g: @escaping Operator<F, G>,
  _ h: @escaping Operator<G, H>,
  _ i: @escaping (Producer<H>) -> I
) -> (@escaping Producer<A>) -> I {
  return { a in return i(h(g(f(e(d(c(b(a)))))))) }
}

public func pipe<A, B, C, D, E, F, G, H, I, J>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>,
  _ g: @escaping Operator<F, G>,
  _ h: @escaping Operator<G, H>,
  _ i: @escaping Operator<H, I>,
  _ j: @escaping (Producer<I>) -> J
) -> (@escaping Producer<A>) -> J {
  return { a in return j(i(h(g(f(e(d(c(b(a))))))))) }
}

public func pipe<A, B, C, D, E, F, G, H, I, J, K>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>,
  _ g: @escaping Operator<F, G>,
  _ h: @escaping Operator<G, H>,
  _ i: @escaping Operator<H, I>,
  _ j: @escaping Operator<I, J>,
  _ k: @escaping (Producer<J>) -> K
) -> (@escaping Producer<A>) -> K {
  return { a in return k(j(i(h(g(f(e(d(c(b(a)))))))))) }
}

public func pipe<A, B, C, D, E, F, G, H, I, J, K, L>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>,
  _ g: @escaping Operator<F, G>,
  _ h: @escaping Operator<G, H>,
  _ i: @escaping Operator<H, I>,
  _ j: @escaping Operator<I, J>,
  _ k: @escaping Operator<J, K>,
  _ l: @escaping (Producer<K>) -> L
) -> (@escaping Producer<A>) -> L {
  return { a in return l(k(j(i(h(g(f(e(d(c(b(a))))))))))) }
}

public func pipe<A, B, C, D, E, F, G, H, I, J, K, L, M>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>,
  _ g: @escaping Operator<F, G>,
  _ h: @escaping Operator<G, H>,
  _ i: @escaping Operator<H, I>,
  _ j: @escaping Operator<I, J>,
  _ k: @escaping Operator<J, K>,
  _ l: @escaping Operator<K, L>,
  _ m: @escaping (Producer<L>) -> M
) -> (@escaping Producer<A>) -> M {
  return { a in return m(l(k(j(i(h(g(f(e(d(c(b(a)))))))))))) }
}

public func pipe<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>,
  _ g: @escaping Operator<F, G>,
  _ h: @escaping Operator<G, H>,
  _ i: @escaping Operator<H, I>,
  _ j: @escaping Operator<I, J>,
  _ k: @escaping Operator<J, K>,
  _ l: @escaping Operator<K, L>,
  _ m: @escaping Operator<L, M>,
  _ n: @escaping (Producer<M>) -> N
) -> (@escaping Producer<A>) -> N {
  return { a in return n(m(l(k(j(i(h(g(f(e(d(c(b(a))))))))))))) }
}

public func pipe<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>,
  _ g: @escaping Operator<F, G>,
  _ h: @escaping Operator<G, H>,
  _ i: @escaping Operator<H, I>,
  _ j: @escaping Operator<I, J>,
  _ k: @escaping Operator<J, K>,
  _ l: @escaping Operator<K, L>,
  _ m: @escaping Operator<L, M>,
  _ n: @escaping Operator<M, N>,
  _ o: @escaping (Producer<N>) -> O
) -> (@escaping Producer<A>) -> O {
  return { a in return o(n(m(l(k(j(i(h(g(f(e(d(c(b(a)))))))))))))) }
}