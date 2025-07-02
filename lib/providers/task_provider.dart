import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  Future<void> fetchTasks() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .orderBy('dueDate')
            .get();

    _tasks =
        snapshot.docs
            .map((doc) => TaskModel.fromMap(doc.id, doc.data()))
            .toList();

    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .add(task.toMap());

    _tasks.add(
      TaskModel(
        id: docRef.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: task.isCompleted,
      ),
    );

    notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());

    int index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(id)
        .delete();

    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
