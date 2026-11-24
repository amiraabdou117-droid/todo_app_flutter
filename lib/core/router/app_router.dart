import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/router/routes.dart';
import 'package:todo_app/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:todo_app/features/auth/presentation/screens/login_screen.dart';
import 'package:todo_app/features/auth/presentation/screens/profile_screen.dart';
import 'package:todo_app/features/auth/presentation/screens/register_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/detail_task_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/edit_task_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:todo_app/features/tasks/presentation/widgets/toolbar_action_theme_widget.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.home,
    refreshListenable: GoRouterRefreshNotifier(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final currentLocation = state.matchedLocation;

      final loggingIn =
          currentLocation == AppRoutes.login ||
          currentLocation == AppRoutes.register;

      if (authState is UnAuthenticatedState && !loggingIn) {
        return AppRoutes.login;
      }

      if (authState is AuthenticatedState && loggingIn) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // Shell for main application layout
      ShellRoute(
        builder: (context, state, child) {
          final location = state.matchedLocation;
          // Flèche retour sur les écrans ajout / détail / modification.
          final showBack = !(location.startsWith(AppRoutes.home) ||
              location.startsWith(AppRoutes.profile));

          return Scaffold(
            appBar: AppBar(
              leading: showBack
                  ? BackButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                    )
                  : null,
              title: const Text('TODO APP'),
              actions: [
                const ActionThemeButton(),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                    // La redirection vers /login est faite par le redirect.
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _calculateIndex(location),
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go(AppRoutes.home);
                    break;
                  case 1:
                    context.go(AppRoutes.profile);
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const TasksScreen(),
          ),
          GoRoute(
            path: AppRoutes.addTask,
            name: 'add_task',
            builder: (context, state) => const AddTaskScreen(),
          ),
          GoRoute(
            path: AppRoutes.detailTask,
            name: 'detail_task',
            builder: (context, state) =>
                DetailTaskScreen(taskId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: AppRoutes.editTask,
            name: 'edit_task',
            builder: (context, state) =>
                EditTaskScreen(taskId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}

int _calculateIndex(String location) {
  if (location.startsWith(AppRoutes.home)) return 0;
  if (location.startsWith(AppRoutes.profile)) return 1;
  return 0;
}

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Stream stream) {
    stream.listen((_) => notifyListeners());
  }
}