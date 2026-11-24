import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/features/tasks/data/models/task_model.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';

void main() {
  final date = DateTime(2026, 11, 23, 10, 30);

    test('fromEntity copie tous les champs de l\'entité', () {
    final entity = TaskEntity(
      id: '1',
      title: 'Titre',
      description: 'Desc',
      isCompleted: true,
      createdAt: date,
    );

    final model = TaskModel.fromEntity(entity);

    // Equatable compare aussi le type (TaskModel != TaskEntity),
    // on compare donc les valeurs des champs.
    expect(model, isA<TaskEntity>());
    expect(model.props, entity.props);
  });

  test('toJson puis fromJson redonne la même tâche', () {
    final model = TaskModel(
      id: 'abc',
      title: 'Titre',
      description: 'Desc',
      createdAt: date,
    );

    final json = model.toJson();
    final back = TaskModel.fromJson(json, id: 'abc');

    expect(json['createdAt'], isA<Timestamp>());
    expect(back, model);
  });

  test('fromJson utilise des valeurs par défaut si les champs manquent', () {
    final model = TaskModel.fromJson({
      'title': 'Titre',
      'createdAt': Timestamp.fromDate(date),
    }, id: 'x');

    expect(model.isCompleted, false);
    expect(model.isDeleted, false);
    expect(model.description, isNull);
  });
}