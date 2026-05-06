// Fibonacci - Akro Language
// by ST

fn fib(n) {
    if n <= 1 { return n }
    return fib(n - 1) + fib(n - 2)
}

fn main {
    say "Fibonacci sequence:"
    for i in 0..=10 {
        say "fib({i}) = {fib(i)}"
    }
}
