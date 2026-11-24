import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  /// Retourne uniquement les tâches non supprimées (isDeleted == false).
  Future<Either<Failure, List<TaskEntity>>> getTasks();

  Future<Either<Failure, TaskEntity>> getTaskById(String id);

  Future<Either<Failure, Unit>> addTask(TaskEntity task);

  Future<Either<Failure, Unit>> updateTask(TaskEntity task);

  /// Suppression logique : la tâche est conservée avec isDeleted = true.
  Future<Either<Failure, Unit>> deleteTask(TaskEntity task);
}