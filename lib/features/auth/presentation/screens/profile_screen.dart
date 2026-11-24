import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/di/service_locator.dart';
import 'package:todo_app/core/firebase/auth_service.dart';
import 'package:todo_app/features/auth/presentation/blocs/auth/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = sl<AuthService>().currentUser;
    final name = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!
        : 'Utilisateur';
    final email = user?.email ?? '';
    final initial = name.characters.first.toUpperCase();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 16),
        Center(
          child: CircleAvatar(
            radius: 48,
            child: Text(initial, style: const TextStyle(fontSize: 36)),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(name, style: Theme.of(context).textTheme.headlineSmall),
        ),
        const SizedBox(height: 4),
        Center(child: Text(email)),
        const SizedBox(height: 32),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Nom'),
                subtitle: Text(name),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('E-mail'),
                subtitle: Text(email),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Se déconnecter'),
          onPressed: () => context.read<AuthBloc>().add(LogoutEvent()),
        ),
      ],
    );
  }
}