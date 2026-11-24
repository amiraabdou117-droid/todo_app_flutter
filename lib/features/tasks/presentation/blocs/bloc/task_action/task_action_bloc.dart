import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/core/failures/task_failures.dart';
import 'package:todo_app/core/strings/failures.dart';
import 'package:todo_app/core/strings/messages.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/domain/usecases/add_task.dart';
import 'package:todo_app/features/tasks/domain/usecases/complete_task.dart';
import 'package:todo_app/features/tasks/domain/usecases/delete_task.dart';
import 'package:todo_app/features/tasks/domain/usecases/update_task.dart';

part 'task_action_event.dart';
part 'task_action_state.dart';

class TaskActionBloc extends Bloc<TaskActionEvent, TaskActionState> {
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final CompleteTask completeTask;

  TaskActionBloc({
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.completeTask,
  }) : super(TaskActionInitial()) {
    on<AddTaskEvent>(_onAdd);
    on<UpdateTaskEvent>(_onUpdate);
    on<DeleteTaskEvent>(_onDelete);
    on<CompleteTaskEvent>(_onComplete);
  }

  Future<void> _onAdd(AddTaskEvent event, Emitter<TaskActionState> emit) async {
    emit(TaskActionLoading());
    // id vide : c'est Firestore qui génère l'identifiant.
    final task = TaskEntity(
      id: '',
      title: event.title.trim(),
      description: event.description?.trim(),
      createdAt: DateTime.now(),
    );
    _emitResult(await addTask(task), ADD_SUCCESS_MESSAGE, emit);
  }

  Future<void> _onUpdate(
    UpdateTaskEvent event,
    Emitter<TaskActionState> emit,
  ) async {
    emit(TaskActionLoading());
    _emitResult(await updateTask(event.task), UPDATE_SUCCESS_MESSAGE, emit);
  }

  Future<void> _onDelete(
    DeleteTaskEvent event,
    Emitter<TaskActionState> emit,
  ) async {
    emit(TaskActionLoading());
    _emitResult(await deleteTask(event.task), DELETE_SUCCESS_MESSAGE, emit);
  }

  Future<void> _onComplete(
    CompleteTaskEvent event,
    Emitter<TaskActionState> emit,
  ) async {
    emit(TaskActionLoading());
    final result = await completeTask(
      event.task,
      isCompleted: event.isCompleted,
    );
    _emitResult(result, UPDATE_SUCCESS_MESSAGE, emit);
  }

  void _emitResult(
    Either<Failure, Unit> result,
    String successMessage,
    Emitter<TaskActionState> emit,
  ) {
    result.fold(
      (failure) => emit(TaskActionError(message: _failureToMessage(failure))),
      (_) => emit(TaskActionSuccess(message: successMessage)),
    );
  }

  String _failureToMessage(Failure failure) {
    if (failure is OfflineFailure) return OFFLINE_FAILURE_MESSAGE;
    if (failure is TaskNotFoundFailure) return 'Tâche introuvable';
    if (failure is ServerFailure) return SERVER_FAILURE_MESSAGE;
    return 'Erreur inconnue';
  }
}