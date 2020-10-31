public func pipe<A, B>(
  _ b: @escaping Operator<A, B>
) -> (@escaping Producer<A>) -> Producer<B> {
  return { a in return b(a) }
}

public func pipe<A, B, C>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>
) -> (@escaping Producer<A>) -> Producer<C> {
  return { a in return c(b(a)) }
}

public func pipe<A, B, C, D>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>
) -> (@escaping Producer<A>) -> Producer<D> {
  return { a in return d(c(b(a))) }
}

public func pipe<A, B, C, D, E>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>
) -> (@escaping Producer<A>) -> Producer<E> {
  return { a in return e(d(c(b(a)))) }
}

public func pipe<A, B, C, D, E, F>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>
) -> (@escaping Producer<A>) -> Producer<F> {
  return { a in return f(e(d(c(b(a))))) }
}

public func pipe<A, B, C, D, E, F, G>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>,
  _ g: @escaping Operator<F, G>
) -> (@escaping Producer<A>) -> Producer<G> {
  return { a in return g(f(e(d(c(b(a)))))) }
}

public func pipe<A, B, C, D, E, F, G, H>(
  _ b: @escaping Operator<A, B>,
  _ c: @escaping Operator<B, C>,
  _ d: @escaping Operator<C, D>,
  _ e: @escaping Operator<D, E>,
  _ f: @escaping Operator<E, F>,
  _ g: @escaping Operator<F, G>,
  _ h: @escaping Operator<G, H>
) -> (@escaping Producer<A>) -> Producer<H> {
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
  _ i: @escaping Operator<H, I>
) -> (@escaping Producer<A>) -> Producer<I> {
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
  _ j: @escaping Operator<I, J>
) -> (@escaping Producer<A>) -> Producer<J> {
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
  _ k: @escaping Operator<J, K>
) -> (@escaping Producer<A>) -> Producer<K> {
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
  _ l: @escaping Operator<K, L>
) -> (@escaping Producer<A>) -> Producer<L> {
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
  _ m: @escaping Operator<L, M>
) -> (@escaping Producer<A>) -> Producer<M> {
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
  _ n: @escaping Operator<M, N>
) -> (@escaping Producer<A>) -> Producer<N> {
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
  _ o: @escaping Operator<N, O>
) -> (@escaping Producer<A>) -> Producer<O> {
  return { a in return o(n(m(l(k(j(i(h(g(f(e(d(c(b(a)))))))))))))) }
}