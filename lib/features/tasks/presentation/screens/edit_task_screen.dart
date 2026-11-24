import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/task_action/task_action_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks/tasks_bloc.dart';
import 'package:todo_app/features/tasks/presentation/widgets/task_form.dart';

class EditTaskScreen extends StatelessWidget {
  final String taskId;

  const EditTaskScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final tasksState = context.watch<TasksBloc>().state;
    final task = tasksState is LoadedTasksState
        ? tasksState.byId(taskId)
        : null;

    if (task == null) {
      return const Center(child: Text('Tâche introuvable'));
    }

    return BlocConsumer<TaskActionBloc, TaskActionState>(
      listener: (context, state) {
        if (state is TaskActionSuccess) context.pop();
      },
      builder: (context, state) {
        return TaskForm(
          initialTask: task,
          submitLabel: 'Enregistrer',
          isLoading: state is TaskActionLoading,
          onSubmit: (title, description) {
            // On reconstruit l'entité (et non copyWith) pour pouvoir
            // vider la description.
            final updated = TaskEntity(
              id: task.id,
              title: title,
              description: description,
              isCompleted: task.isCompleted,
              isDeleted: task.isDeleted,
              createdAt: task.createdAt,
            );
            context.read<TaskActionBloc>().add(UpdateTaskEvent(task: updated));
          },
        );
      },
    );
  }
}