import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:todo_app/core/firebase/auth_service.dart';
import 'package:todo_app/core/network/network_info.dart';
import 'package:todo_app/core/router/app_router.dart';
import 'package:todo_app/features/auth/data/datasources/user_data_source.dart';
import 'package:todo_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:todo_app/features/auth/domain/repositories/user_repository.dart';
import 'package:todo_app/features/auth/domain/usecases/register_user.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_in_user.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_out_user.dart';
import 'package:todo_app/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:todo_app/features/auth/presentation/blocs/register/register_bloc.dart';
import 'package:todo_app/features/tasks/data/datasources/task_data_source.dart';
import 'package:todo_app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:todo_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:todo_app/features/tasks/domain/usecases/add_task.dart';
import 'package:todo_app/features/tasks/domain/usecases/complete_task.dart';
import 'package:todo_app/features/tasks/domain/usecases/delete_task.dart';
import 'package:todo_app/features/tasks/domain/usecases/get_task.dart';
import 'package:todo_app/features/tasks/domain/usecases/get_tasks.dart';
import 'package:todo_app/features/tasks/domain/usecases/update_task.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/switchtheme_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/task_action/task_action_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks/tasks_bloc.dart';
import 'package:todo_app/firebase_options.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Firebase first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register Auth service
  sl.registerLazySingleton<AuthService>(
    () => AuthService(FirebaseAuth.instance),
  );

  // Core
  sl.registerLazySingleton<NetwortkInfo>(
    () => NetwortkInfoImpl(sl()),
  );
  sl.registerLazySingleton(
    () => InternetConnectionChecker.createInstance(),
  );

  // find and instanciate AppRouter
  sl.registerLazySingleton(() => AppRouter(authBloc: sl()));

  // find and instanciate SwitchthemeBloc
  sl.registerLazySingleton(() => SwitchthemeBloc());

  // ---------------------------------------------------------------------------
  // Feature Auth
  // ---------------------------------------------------------------------------
  // Datasource
  sl.registerLazySingleton<UserDataSource>(
    () => UserDataSourceImpl(authService: sl()),
  );

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      userDataSource: sl(),
      networkInfo: sl(),
      authService: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => SignInUserUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUserUseCase(sl()));

  // Auth Bloc
  sl.registerLazySingleton(
    () => AuthBloc(
      signInUserUseCase: sl(),
      signOutUserUseCase: sl(),
      authService: sl(),
    ),
  );

  // Register Bloc
  sl.registerLazySingleton(
    () => RegisterBloc(registerUserUseCase: sl()),
  );

  // ---------------------------------------------------------------------------
  // Feature Tasks
  // ---------------------------------------------------------------------------
  // Firestore
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Datasource
  sl.registerLazySingleton<TaskDataSource>(
    () => TaskDataSourceImpl(firestore: sl(), authService: sl()),
  );

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(taskDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => GetTaskById(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => CompleteTask(sl()));

  // Blocs : registerFactory (une nouvelle instance à chaque demande)
  sl.registerFactory(() => TasksBloc(getTasks: sl()));
  sl.registerFactory(
    () => TaskActionBloc(
      addTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
      completeTask: sl(),
    ),
  );
}