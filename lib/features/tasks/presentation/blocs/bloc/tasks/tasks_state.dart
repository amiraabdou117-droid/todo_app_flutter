part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {}

class LoadingTasksState extends TasksState {}

class LoadedTasksState extends TasksState {
  final List<TaskEntity> tasks;

  const LoadedTasksState({required this.tasks});

  TaskEntity? byId(String id) {
    for (final task in tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  @override
  List<Object?> get props => [tasks];
}

class EmptyTasksState extends TasksState {}

class ErrorTasksState extends TasksState {
  final String message;

  const ErrorTasksState({required this.message});

  @override
  List<Object?> get props => [message];
}