import 'package:flutter/material.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';

class TaskForm extends StatefulWidget {
  final TaskEntity? initialTask;
  final String submitLabel;
  final bool isLoading;
  final void Function(String title, String? description) onSubmit;

  const TaskForm({
    super.key,
    this.initialTask,
    required this.submitLabel,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTask?.title);
    _descriptionController = TextEditingController(
      text: widget.initialTask?.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final description = _descriptionController.text.trim();
    widget.onSubmit(
      _titleController.text.trim(),
      description.isEmpty ? null : description,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Titre',
              border: OutlineInputBorder(),
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Le titre est obligatoire'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (facultatif)',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: widget.isLoading ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.submitLabel),
          ),
        ],
      ),
    );
  }
}