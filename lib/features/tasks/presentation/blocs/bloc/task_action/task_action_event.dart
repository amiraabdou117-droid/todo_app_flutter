part of 'task_action_bloc.dart';

abstract class TaskActionEvent extends Equatable {
  const TaskActionEvent();

  @override
  List<Object?> get props => [];
}

class AddTaskEvent extends TaskActionEvent {
  final String title;
  final String? description;

  const AddTaskEvent({required this.title, this.description});

  @override
  List<Object?> get props => [title, description];
}

class UpdateTaskEvent extends TaskActionEvent {
  final TaskEntity task;

  const UpdateTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskActionEvent {
  final TaskEntity task;

  const DeleteTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class CompleteTaskEvent extends TaskActionEvent {
  final TaskEntity task;
  final bool isCompleted;

  const CompleteTaskEvent({required this.task, this.isCompleted = true});

  @override
  List<Object?> get props => [task, isCompleted];
}