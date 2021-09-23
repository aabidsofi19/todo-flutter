import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class TodoModal {
  final String task;
  bool? finished;
  TodoModal({required this.task, required this.finished});
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Todo Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Todo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TodoModal> todos = [];

  void completeTask(TodoModal todo, var value) {
    setState(() {
      todo.finished = value;
    });
    //todo.finished = true;
    print(value);
  }

  void _formPopup(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            child: AddTodoForm(addTodo: addTodo),
          ),
        );
      },
    );
  }

  void addTodo(String todo) {
    setState(() {
      todos.add(TodoModal(task: todo, finished: false));
    });
  }

  void removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
      print(todos.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontFamily: 'Roboto',
            letterSpacing: 0.5,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.,
          children: <Widget>[
            Todos(
                todos_list: todos,
                delete: removeTodo,
                completeTask: completeTask),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _formPopup(context);
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class AddTodoForm extends StatefulWidget {
  AddTodoForm({Key? key, required this.addTodo}) : super(key: key);
  Function addTodo;
  @override
  AddTodoState createState() => AddTodoState();
}

class AddTodoState extends State<AddTodoForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
                minLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: "add new todo."),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (value) {
                  widget.addTodo(value);
                  
                  Navigator.of(context).pop();
                }),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                 
                }
              },
              child: Text("Add Todo"),
            ),
          ),
        ],
      ),
    );
  }
}

class Todos extends StatelessWidget {
  List<TodoModal> todos_list;
  Function delete;
  Function completeTask;
  Todos(
      {Key? key,
      required this.todos_list,
      required this.delete,
      required this.completeTask})
      : super(key: key);

  List<Widget> todos(List<TodoModal> todos_list) {
    List<Widget> todos_widgets = [];
    for (var i = 0; i < todos_list.length; i++) {
      Widget todoCard = TodoCard(
          todo: todos_list[i],
          delete: delete,
          index: i,
          completeTask: completeTask);
      todos_widgets.add(todoCard);
    }

    return todos_widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: todos(todos_list),
    );
  }
}

class TodoCard extends StatelessWidget {
  //TodoCard({Key?key , required this.text}): super(key:key);
  TodoCard(
      {Key? key,
      required this.todo,
      required this.delete,
      required this.index,
      required this.completeTask})
      : super(key: key);
  final TodoModal todo;
  Function delete;
  Function completeTask;
  final int index;

  TextStyle textStyle(TodoModal todo) {
    if (todo.finished == true) {
      return TextStyle(color: Colors.grey,decoration: TextDecoration.lineThrough);
    } else {
      return TextStyle(color: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red, child:Icon(Icons.delete)),
      onDismissed: (direction) {
        delete(index);
      },
      key: Key(todo.task),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
          child: Row(children: <Widget>[
            Checkbox(
              value: todo.finished,
              onChanged: (var value) {
                completeTask(todo, value);
                print("hi");
              },
            ),
            Text(
              todo.task,
              style: textStyle(todo),
            ),
          ]),
        ),
      ),
    );
  }
}
