import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:todo_app/features/tasks/domain/usecases/complete_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class FakeTaskEntity extends Fake implements TaskEntity {}

void main() {
  late MockTaskRepository repository;
  late CompleteTask completeTask;

  final task = TaskEntity(
    id: '1',
    title: 'Réviser Flutter',
    createdAt: DateTime(2026, 11, 23),
  );

  setUpAll(() {
    registerFallbackValue(FakeTaskEntity());
  });

  setUp(() {
    repository = MockTaskRepository();
    completeTask = CompleteTask(repository);
  });

  test('marque la tâche comme terminée via updateTask', () async {
    when(() => repository.updateTask(any()))
        .thenAnswer((_) async => const Right(unit));

    final result = await completeTask(task);

    expect(result, const Right(unit));
    verify(() => repository.updateTask(task.copyWith(isCompleted: true)))
        .called(1);
    verifyNoMoreInteractions(repository);
  });

  test('peut décocher une tâche (isCompleted: false)', () async {
    final done = task.copyWith(isCompleted: true);
    when(() => repository.updateTask(any()))
        .thenAnswer((_) async => const Right(unit));

    await completeTask(done, isCompleted: false);

    verify(() => repository.updateTask(done.copyWith(isCompleted: false)))
        .called(1);
  });

  test('retourne un Left quand le repository échoue', () async {
    when(() => repository.updateTask(any()))
        .thenAnswer((_) async => Left(ServerFailure()));

    final result = await completeTask(task);

    expect(result.isLeft(), true);
  });
}