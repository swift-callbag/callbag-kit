public func pipe<A, B>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>
) -> Producer<B> {
  return b(a)
}

public func pipe<A, B, C>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>
) -> Producer<C> {
  return c(b(a))
}

public func pipe<A, B, C, D>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>
) -> Producer<D> {
  return d(c(b(a)))
}

public func pipe<A, B, C, D, E>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>,
  _ e: Operator<D, E>
) -> Producer<E> {
  return e(d(c(b(a))))
}

public func pipe<A, B, C, D, E, F>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>,
  _ e: Operator<D, E>,
  _ f: Operator<E, F>
) -> Producer<F> {
  return f(e(d(c(b(a)))))
}

public func pipe<A, B, C, D, E, F, G>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>,
  _ e: Operator<D, E>,
  _ f: Operator<E, F>,
  _ g: Operator<F, G>
) -> Producer<G> {
  return g(f(e(d(c(b(a))))))
}

public func pipe<A, B, C, D, E, F, G, H>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>,
  _ e: Operator<D, E>,
  _ f: Operator<E, F>,
  _ g: Operator<F, G>,
  _ h: Operator<G, H>
) -> Producer<H> {
  return h(g(f(e(d(c(b(a)))))))
}

public func pipe<A, B, C, D, E, F, G, H, I>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>,
  _ e: Operator<D, E>,
  _ f: Operator<E, F>,
  _ g: Operator<F, G>,
  _ h: Operator<G, H>,
  _ i: Operator<H, I>
) -> Producer<I> {
  return i(h(g(f(e(d(c(b(a))))))))
}

public func pipe<A, B, C, D, E, F, G, H, I, J>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>,
  _ e: Operator<D, E>,
  _ f: Operator<E, F>,
  _ g: Operator<F, G>,
  _ h: Operator<G, H>,
  _ i: Operator<H, I>,
  _ j: Operator<I, J>
) -> Producer<J> {
  return j(i(h(g(f(e(d(c(b(a)))))))))
}

public func pipe<A, B, C, D, E, F, G, H, I, J, K>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>,
  _ e: Operator<D, E>,
  _ f: Operator<E, F>,
  _ g: Operator<F, G>,
  _ h: Operator<G, H>,
  _ i: Operator<H, I>,
  _ j: Operator<I, J>,
  _ k: Operator<J, K>
) -> Producer<K> {
  return k(j(i(h(g(f(e(d(c(b(a))))))))))
}

public func pipe<A, B, C, D, E, F, G, H, I, J, K, L>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>,
  _ e: Operator<D, E>,
  _ f: Operator<E, F>,
  _ g: Operator<F, G>,
  _ h: Operator<G, H>,
  _ i: Operator<H, I>,
  _ j: Operator<I, J>,
  _ k: Operator<J, K>,
  _ l: Operator<K, L>
) -> Producer<L> {
  return l(k(j(i(h(g(f(e(d(c(b(a)))))))))))
}

public func pipe<A, B, C, D, E, F, G, H, I, J, K, L, M>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>,
  _ e: Operator<D, E>,
  _ f: Operator<E, F>,
  _ g: Operator<F, G>,
  _ h: Operator<G, H>,
  _ i: Operator<H, I>,
  _ j: Operator<I, J>,
  _ k: Operator<J, K>,
  _ l: Operator<K, L>,
  _ m: Operator<L, M>
) -> Producer<M> {
  return m(l(k(j(i(h(g(f(e(d(c(b(a))))))))))))
}

public func pipe<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>,
  _ e: Operator<D, E>,
  _ f: Operator<E, F>,
  _ g: Operator<F, G>,
  _ h: Operator<G, H>,
  _ i: Operator<H, I>,
  _ j: Operator<I, J>,
  _ k: Operator<J, K>,
  _ l: Operator<K, L>,
  _ m: Operator<L, M>,
  _ n: Operator<M, N>
) -> Producer<N> {
  return n(m(l(k(j(i(h(g(f(e(d(c(b(a)))))))))))))
}

public func pipe<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
  _ a: @escaping Producer<A>,
  _ b: Operator<A, B>,
  _ c: Operator<B, C>,
  _ d: Operator<C, D>,
  _ e: Operator<D, E>,
  _ f: Operator<E, F>,
  _ g: Operator<F, G>,
  _ h: Operator<G, H>,
  _ i: Operator<H, I>,
  _ j: Operator<I, J>,
  _ k: Operator<J, K>,
  _ l: Operator<K, L>,
  _ m: Operator<L, M>,
  _ n: Operator<M, N>,
  _ o: Operator<N, O>
) -> Producer<O> {
  return o(n(m(l(k(j(i(h(g(f(e(d(c(b(a))))))))))))))
}