import 'package:dartz/dartz.dart';
import 'package:todo_app/core/exceptions/exceptions.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/core/failures/task_failures.dart';
import 'package:todo_app/core/network/network_info.dart';
import 'package:todo_app/features/tasks/data/datasources/task_data_source.dart';
import 'package:todo_app/features/tasks/data/models/task_model.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource taskDataSource;
  final NetwortkInfo networkInfo;

  TaskRepositoryImpl({
    required this.taskDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    if (await networkInfo.isConnected) {
      try {
        final tasks = await taskDataSource.getTasks();
        return Right(tasks);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final task = await taskDataSource.getTaskById(id);
        return Right(task);
      } on TaskNotFoundException {
        return Left(TaskNotFoundFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addTask(TaskEntity task) async {
    // Adapter Entity -> Model
    final taskModel = TaskModel.fromEntity(task);
    if (await networkInfo.isConnected) {
      try {
        await taskDataSource.addTask(taskModel);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    if (await networkInfo.isConnected) {
      try {
        await taskDataSource.updateTask(taskModel);
        return const Right(unit);
      } on TaskNotFoundException {
        return Left(TaskNotFoundFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    if (await networkInfo.isConnected) {
      try {
        await taskDataSource.deleteTask(taskModel);
        return const Right(unit);
      } on TaskNotFoundException {
        return Left(TaskNotFoundFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}