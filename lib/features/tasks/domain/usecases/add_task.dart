import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<Either<Failure, Unit>> call(TaskEntity task) {
    return repository.addTask(task);
  }
}