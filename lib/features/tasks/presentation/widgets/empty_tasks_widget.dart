import 'package:flutter/material.dart';

class EmptyTasksWidget extends StatelessWidget {
  const EmptyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.checklist, size: 64),
          SizedBox(height: 12),
          Text('Aucune tâche pour le moment'),
          Text('Appuie sur + pour en ajouter une'),
        ],
      ),
    );
  }
}