import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Repo/login_state.dart';
import 'package:todo/ViewModel/application_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginState(),
      builder: (context, _) => App(),
    )
  );
}
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "TODO",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("TODO"),
      ),
      body: ListView(
        children: [
          Consumer<LoginState>(
            builder: (context, loginState, _) => Padding(padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
              child: Authentication(
              email: loginState.email,
              appLoginState: loginState.appLoginState,
              startLoginFlow: loginState.startLoginFlow,
              verifyEmail: loginState.verifyEmail,
              signIn: loginState.signIn,
              cancel: loginState.cancel,
              signUp: loginState.signUp,
              signOut: loginState.signOut,
            ),
            ),

          ),
          Consumer<LoginState>(
            builder: (context,loginState, _) => Column(
              children: [
                if(loginState.appLoginState == AppLoginState.loggedIn)...[
                  const SizedBox(height: 8,),
                  TodoList(addTodo: loginState.addTodo, todoList: loginState.todoList, changeTodoState: loginState.changeTodoState,),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}
class TodoList extends StatefulWidget {
  const TodoList({Key? key, required this.addTodo, required this.todoList, required this.changeTodoState}) : super(key: key);
  final FutureOr<void> Function(String todo) addTodo;
  final List<Todo> todoList;
  final FutureOr<void> Function(String todo, bool done) changeTodoState;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _todoFormField = GlobalKey<FormState>();
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(

    children: [Padding(
        padding: const EdgeInsets.all(8.0),
    child: Form(
      key: _todoFormField,
      child: Row(
        children: [
          Expanded(child: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Add Todo",
            ),
            validator: (value) {
              if(value == null || value.isEmpty){
                return "Enter your message to continue";
              }
              return null;
            },
          ),
          ),
          const SizedBox(width: 8,),
          ElevatedButton(onPressed: () async {
            if(_todoFormField.currentState!.validate()) {
              try {
                await widget.addTodo( _controller.text);
              } on Exception catch (e, _){
                log(e.toString());
            }
            }
          }, child: const Text("Add"),
          ),

        ],
      ),
    ),
    ),
      const SizedBox(height: 8,),
      for(var todo in widget.todoList)
        Padding(padding: const EdgeInsets.all(8.0),
        child:Row(
          children: [
            IconButton(
              onPressed: (){
            widget.changeTodoState(todo.id, !todo.done);},
              icon: getCheckBox(todo),
              iconSize: 36.0,
            ),
            Text(todo.todo ,
            style: const TextStyle(
              fontSize: 32.0
            ),
            ),
          ],
        ),
    ),

    ]
    );
  }
  Widget getCheckBox(Todo todo) {
    if(todo.done){
      return const Icon(Icons.check_box_outlined);
    }else{
      return const Icon(Icons.check_box_outline_blank_sharp);
    }
  }
}

