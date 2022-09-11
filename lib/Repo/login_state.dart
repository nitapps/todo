import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/ViewModel/application_state.dart';
import 'package:todo/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginState extends ChangeNotifier {
  AppLoginState _appLoginState = AppLoginState.loggedOut;
  AppLoginState get appLoginState => _appLoginState;

  String? _email;
  String? get email => _email;

  StreamSubscription<QuerySnapshot>? _todoSubscription;
  List<Todo> _todoList = [];
  List<Todo> get todoList => _todoList;

  LoginState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _appLoginState = AppLoginState.loggedIn;
        _todoSubscription = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid.toString())
        .orderBy('time', descending: true)
        .snapshots()
        .listen((snapshot) {
          _todoList = [];
          for (final document in snapshot.docs) {
            _todoList.add(
              Todo(todo: document.data()['todo'] as String,
                  done: document.data()['done'] as bool,
              time: DateTime.fromMillisecondsSinceEpoch(document.data()['time']),
              id: document.data()['id'] as String),
            );
          }
          notifyListeners();
          log(todoList.length.toString());
        });

      } else {
        _appLoginState = AppLoginState.loggedOut;
        _todoList = [];
        _todoSubscription?.cancel();
      }
      notifyListeners();
    });

  }
   addTodo(String todo) async {
    if(_appLoginState != AppLoginState.loggedIn){
      log("user must be logged in");
    }
    final docRef = FirebaseFirestore.instance
    .collection(FirebaseAuth.instance.currentUser!.uid)
    .doc();
    await docRef.set(<String, dynamic> {
      'todo' : todo,
      'done' : false,
      'time' :DateTime.now().millisecondsSinceEpoch,
      'id': docRef.id

    });

    /*var documentReference =  FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .add(<String, dynamic> {
          'todo' : todo.todo,
      'done' : todo.done,
      'time' :DateTime.now().millisecondsSinceEpoch,
    });*/

  }
  changeTodoState(String id, bool done) async {
    await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid.toString())
        .doc(id).update({'done': done});
  }

  void startLoginFlow(){
    _appLoginState = AppLoginState.email;
    notifyListeners();
  }


  Future<void> verifyEmail(String email) async {
    try{
      var signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if(signInMethods.contains('password')){
        _appLoginState = AppLoginState.password;
      } else {
        _appLoginState = AppLoginState.signUp;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException {
      rethrow;
    }
  }
  Future<void> signIn( String email, String password) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }
  void cancel(){
    _appLoginState = AppLoginState.email;
  notifyListeners();
  }
  Future<void> signUp(
  String email,
  String password,
  String name) async {
    try{
      var credential = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (e){
      log(e.toString());
    }
  }
  void signOut(){
    FirebaseAuth.instance.signOut();
  }

}

class Todo{
  final String todo;
  bool done;
  String id;
  DateTime time;
  Todo({required this.todo, this.done = false,required this.time, required this.id});

}
