// Simple Calculator - Akro Language
// by ST

fn add(a, b)      { return a + b }
fn subtract(a, b) { return a - b }
fn multiply(a, b) { return a * b }
fn divide(a, b) {
    if b == 0 {
        say "Error: Division by zero!"
        return nil
    }
    return a / b
}

fn main {
    say "=== Akro Calculator ==="
    say "10 + 5 = {add(10, 5)}"
    say "10 - 5 = {subtract(10, 5)}"
    say "10 * 5 = {multiply(10, 5)}"
    say "10 / 5 = {divide(10, 5)}"
    say "10 / 0 = {divide(10, 0)}"
}
