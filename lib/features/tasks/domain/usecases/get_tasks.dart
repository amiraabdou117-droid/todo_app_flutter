import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<Either<Failure, List<TaskEntity>>> call() {
    return repository.getTasks();
  }
}