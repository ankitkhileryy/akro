// Todo App - Akro Language
// by ST

todos := []

fn add_todo(task) {
    todos = append(todos, task)
    say "Added: {task}"
}

fn show_todos {
    if len(todos) == 0 {
        say "No todos yet!"
        return
    }
    say "=== Your Todos ==="
    for i, task in todos {
        say "{i + 1}. {task}"
    }
}

fn remove_todo(index) {
    if index < 1 or index > len(todos) {
        say "Invalid index!"
        return
    }
    task := todos[index - 1]
    todos = slice(todos, 0, index - 1)
    say "Removed: {task}"
}

fn main {
    add_todo("Learn Akro")
    add_todo("Build a project")
    add_todo("Share with friends")
    show_todos()
    remove_todo(2)
    show_todos()
}
