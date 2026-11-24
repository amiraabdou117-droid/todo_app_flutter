import 'package:flutter/material.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';

class TaskTile extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hasDescription =
        task.description != null && task.description!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) => onToggle(value ?? false),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: hasDescription
            ? Text(
                task.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}