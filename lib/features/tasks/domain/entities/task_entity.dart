import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final bool isDeleted;
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.isDeleted = false,
    required this.createdAt,
  });

  /// Retourne une copie de la tâche avec les champs modifiés.
  /// Limite : `description` ne peut pas être remise à null avec cette méthode.
  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    bool? isDeleted,
    DateTime? createdAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isCompleted,
    isDeleted,
    createdAt,
  ];
}