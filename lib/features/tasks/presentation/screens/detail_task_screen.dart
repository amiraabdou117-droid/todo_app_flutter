import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/strings/messages.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/task_action/task_action_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks/tasks_bloc.dart';

class DetailTaskScreen extends StatelessWidget {
  final String taskId;

  const DetailTaskScreen({super.key, required this.taskId});

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final tasksState = context.watch<TasksBloc>().state;
    final TaskEntity? task = tasksState is LoadedTasksState
        ? tasksState.byId(taskId)
        : null;

    if (task == null) {
      return const Center(child: Text('Tâche introuvable'));
    }

    return BlocListener<TaskActionBloc, TaskActionState>(
      listener: (context, state) {
        // On ferme l'écran seulement après une suppression.
        if (state is TaskActionSuccess &&
            state.message == DELETE_SUCCESS_MESSAGE) {
          context.pop();
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Créée le ${_formatDate(task.createdAt)}'),
          const SizedBox(height: 16),
          Text(
            (task.description == null || task.description!.isEmpty)
                ? 'Aucune description'
                : task.description!,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Terminée'),
            value: task.isCompleted,
            onChanged: (value) => context.read<TaskActionBloc>().add(
              CompleteTaskEvent(task: task, isCompleted: value),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Modifier'),
                  onPressed: () => context.pushNamed(
                    'edit_task',
                    pathParameters: {'id': task.id},
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Supprimer'),
                  onPressed: () => context.read<TaskActionBloc>().add(
                    DeleteTaskEvent(task: task),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}