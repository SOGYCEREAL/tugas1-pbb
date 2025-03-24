import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: TodoList()));

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class Todo {
  String task;
  String description;

  bool isDone;

  Todo({
    required this.task,
    required this.description,
    this.isDone = false,
  });
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [
    Todo(task: 'Buy groceries', description: 'Milk, Eggs, Bread, Fruits'),
    Todo(task: 'Do PBB Task', description: 'CRUD Flutter Project'),
    Todo(task: 'Workout', description: 'Go for a run at 6 PM'),
  ];

  void editTodo(Todo todo) {
    final taskController = TextEditingController(text: todo.task);
    final descriptionController = TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: InputDecoration(labelText: 'Task'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  todo.task = taskController.text;
                  todo.description = descriptionController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void addTodo() {
    final taskController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: InputDecoration(labelText: 'Task'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  todos.add(Todo(
                    task: taskController.text,
                    description: descriptionController.text,
                  ));
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void toggleTodo(Todo todo){
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Todo List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(45, 51, 107, 1.0),
      ),
      body: ListView(
        children: todos
            .map(
              (todo) => TodoCard(
            todo: todo,
            delete: () {
              setState(() {
                todos.remove(todo);
              });
            },
            edit: () => editTodo(todo),
            toggleCheckbox: () => toggleTodo(todo),
          ),
        )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        backgroundColor: Color.fromRGBO(45, 51, 107, 1.0),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback delete;
  final VoidCallback edit;
  final VoidCallback toggleCheckbox;

  const TodoCard({
    required this.todo,
    required this.delete,
    required this.edit,
    required this.toggleCheckbox,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Checkbox(
                  value: todo.isDone,
                  onChanged: (bool? newValue) {
                    toggleCheckbox();
                  },
                  activeColor: Color.fromRGBO(45, 51, 107, 1.0),
                ),
                Expanded(
                  child: Text(
                    todo.task,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: todo.isDone
                          ? Colors.grey
                          : Color.fromRGBO(120, 134, 199, 1.0),
                      fontWeight: FontWeight.bold,
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              todo.description,
              style: TextStyle(
                fontSize: 16.0,
                color: todo.isDone
                    ? Colors.grey
                    : Color.fromRGBO(169, 181, 223, 1.0),
                decoration: todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: edit,
                  icon: Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: delete,
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}