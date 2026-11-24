import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/task_action/task_action_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks/tasks_bloc.dart';
import 'package:todo_app/features/tasks/presentation/widgets/empty_tasks_widget.dart';
import 'package:todo_app/features/tasks/presentation/widgets/task_tile.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    // Chargement de la liste quand l'écran s'affiche (utilisateur connecté).
    context.read<TasksBloc>().add(GetAllTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskActionBloc, TaskActionState>(
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state is TaskActionSuccess) {
          messenger.showSnackBar(SnackBar(content: Text(state.message)));
          context.read<TasksBloc>().add(RefreshTasksEvent());
        } else if (state is TaskActionError) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.pushNamed('add_task'),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<TasksBloc, TasksState>(
          builder: (context, state) {
            if (state is LoadingTasksState || state is TasksInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is EmptyTasksState) {
              return const EmptyTasksWidget();
            }
            if (state is ErrorTasksState) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () =>
                          context.read<TasksBloc>().add(GetAllTasksEvent()),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }
            final tasks = (state as LoadedTasksState).tasks;
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 88),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskTile(
                  task: task,
                  onTap: () => context.pushNamed(
                    'detail_task',
                    pathParameters: {'id': task.id},
                  ),
                  onToggle: (value) => context.read<TaskActionBloc>().add(
                    CompleteTaskEvent(task: task, isCompleted: value),
                  ),
                  onDelete: () => context.read<TaskActionBloc>().add(
                    DeleteTaskEvent(task: task),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}