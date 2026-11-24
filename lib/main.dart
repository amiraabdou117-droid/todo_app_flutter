import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:todo_app/core/router/app_router.dart';
import 'package:todo_app/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:todo_app/features/auth/presentation/blocs/register/register_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/switchtheme_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/task_action/task_action_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks/tasks_bloc.dart';

import 'core/di/service_locator.dart' as di;
import 'core/themes/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<SwitchthemeBloc>()),
        BlocProvider(create: (context) => di.sl<RegisterBloc>()),
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
        BlocProvider(create: (context) => di.sl<TasksBloc>()),
        BlocProvider(create: (context) => di.sl<TaskActionBloc>()),
      ],
      child: BlocBuilder<SwitchthemeBloc, SwitchthemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'TODO APP',
            debugShowCheckedModeBanner: false,
            theme: state.themeValue
                ? AppThemes.appThemeData[AppTheme.lightTheme]
                : AppThemes.appThemeData[AppTheme.darkTheme],
            routerConfig: di.sl<AppRouter>().router,
          );
        },
      ),
    );
  }
}