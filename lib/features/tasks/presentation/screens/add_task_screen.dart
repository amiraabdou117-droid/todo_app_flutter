import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/task_action/task_action_bloc.dart';
import 'package:todo_app/features/tasks/presentation/widgets/task_form.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskActionBloc, TaskActionState>(
      listener: (context, state) {
        if (state is TaskActionSuccess) context.pop();
      },
      builder: (context, state) {
        return TaskForm(
          submitLabel: 'Ajouter',
          isLoading: state is TaskActionLoading,
          onSubmit: (title, description) => context.read<TaskActionBloc>().add(
            AddTaskEvent(title: title, description: description),
          ),
        );
      },
    );
  }
}