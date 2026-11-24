import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/core/exceptions/exceptions.dart';
import 'package:todo_app/core/firebase/auth_service.dart';
import 'package:todo_app/features/tasks/data/models/task_model.dart';

abstract class TaskDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskById(String id);
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(TaskModel task);
}

class TaskDataSourceImpl implements TaskDataSource {
  final FirebaseFirestore firestore;
  final AuthService authService;

  TaskDataSourceImpl({required this.firestore, required this.authService});

  /// users/{uid}/tasks
  CollectionReference<Map<String, dynamic>> get _tasksCollection {
    final uid = authService.currentUser?.uid;
    if (uid == null) {
      // Aucun utilisateur connecté : on ne peut pas accéder à ses tâches.
      throw ServerException();
    }
    return firestore.collection('users').doc(uid).collection('tasks');
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final snapshot = await _tasksCollection
          .where('isDeleted', isEqualTo: false)
          .get();
      final tasks = snapshot.docs.map(TaskModel.fromFirestore).toList();
      // Tri en Dart (évite un index composite Firestore) : plus récentes d'abord.
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return tasks;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final doc = await _tasksCollection.doc(id).get();
      if (!doc.exists) throw TaskNotFoundException();
      final task = TaskModel.fromFirestore(doc);
      if (task.isDeleted) throw TaskNotFoundException();
      return task;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<void> addTask(TaskModel task) async {
    try {
      // L'id de l'entité est ignoré : Firestore génère l'identifiant.
      await _tasksCollection.add(task.toJson());
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      await _tasksCollection.doc(task.id).update(task.toJson());
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') throw TaskNotFoundException();
      throw ServerException();
    }
  }

  @override
  Future<void> deleteTask(TaskModel task) async {
    try {
      // Suppression logique
      await _tasksCollection.doc(task.id).update({'isDeleted': true});
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') throw TaskNotFoundException();
      throw ServerException();
    }
  }
}