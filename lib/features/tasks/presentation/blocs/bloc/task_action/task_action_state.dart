part of 'task_action_bloc.dart';

abstract class TaskActionState extends Equatable {
  const TaskActionState();

  @override
  List<Object?> get props => [];
}

class TaskActionInitial extends TaskActionState {}

class TaskActionLoading extends TaskActionState {}

class TaskActionSuccess extends TaskActionState {
  final String message;

  const TaskActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class TaskActionError extends TaskActionState {
  final String message;

  const TaskActionError({required this.message});

  @override
  List<Object?> get props => [message];
}