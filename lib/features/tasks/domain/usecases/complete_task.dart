import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/domain/repositories/task_repository.dart';

class CompleteTask {
  final TaskRepository repository;

  CompleteTask(this.repository);

  /// Marque la tâche comme terminée (ou non terminée si [isCompleted] = false).
  Future<Either<Failure, Unit>> call(
    TaskEntity task, {
    bool isCompleted = true,
  }) {
    return repository.updateTask(task.copyWith(isCompleted: isCompleted));
  }
}