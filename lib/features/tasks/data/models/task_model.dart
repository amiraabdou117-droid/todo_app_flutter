import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    super.isCompleted = false,
    super.isDeleted = false,
    required super.createdAt,
  });

  /// Adapter Entity -> Model
  factory TaskModel.fromEntity(TaskEntity task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      isDeleted: task.isDeleted,
      createdAt: task.createdAt,
    );
  }

  /// L'id n'est pas dans les données : c'est l'id du document Firestore.
  factory TaskModel.fromJson(Map<String, dynamic> json, {required String id}) {
    return TaskModel(
      id: id,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  factory TaskModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return TaskModel.fromJson(doc.data()!, id: doc.id);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'isDeleted': isDeleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}