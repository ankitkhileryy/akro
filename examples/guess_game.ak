// Number Guessing Game - Akro Language
// by ST

fn main {
    secret := rand_int(1, 100)
    attempts := 0
    max_tries := 7

    say "=== Akro Guessing Game ==="
    say "Guess a number between 1 and 100"
    say "You have {max_tries} tries!"
    say ""

    while attempts < max_tries {
        guess_str := input("Your guess: ")
        guess := int(guess_str)
        attempts += 1

        if guess == secret {
            say "Correct! You got it in {attempts} tries!"
            return
        } elif guess < secret {
            say "Too low! {max_tries - attempts} tries left."
        } else {
            say "Too high! {max_tries - attempts} tries left."
        }
    }

    say "Game over! The number was {secret}"
}
