import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/core/failures/task_failures.dart';
import 'package:todo_app/core/strings/failures.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/domain/usecases/get_tasks.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasks getTasks;

  TasksBloc({required this.getTasks}) : super(TasksInitial()) {
    on<GetAllTasksEvent>(_onLoad);
    on<RefreshTasksEvent>(_onLoad);
  }

  Future<void> _onLoad(TasksEvent event, Emitter<TasksState> emit) async {
    // Le refresh ne remet pas l'écran en chargement (pull-to-refresh).
    if (event is GetAllTasksEvent) emit(LoadingTasksState());

    final result = await getTasks();
    result.fold(
      (failure) => emit(ErrorTasksState(message: _failureToMessage(failure))),
      (tasks) => tasks.isEmpty
          ? emit(EmptyTasksState())
          : emit(LoadedTasksState(tasks: tasks)),
    );
  }

  String _failureToMessage(Failure failure) {
    if (failure is OfflineFailure) return OFFLINE_FAILURE_MESSAGE;
    if (failure is TaskNotFoundFailure) return 'Tâche introuvable';
    if (failure is ServerFailure) return SERVER_FAILURE_MESSAGE;
    return 'Erreur inconnue';
  }
}