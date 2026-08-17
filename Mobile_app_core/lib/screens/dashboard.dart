import 'package:flutter/material.dart';
import 'package:mobile_app_core/models/user_role.dart';

class Dashboard extends StatelessWidget {
  final UserRole role;

  const Dashboard({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    String roleText;
    switch (role) {
      case UserRole.farmer:
        roleText = 'Farmer';
        break;
      case UserRole.veterinarian:
        roleText = 'Veterinarian';
        break;
      case UserRole.authority:
        roleText = 'Authority';
        break;
      case UserRole.consumer:
        roleText = 'Consumer';
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: scheme.primary,
      ),
      body: Center(
        child: Text(
          'Welcome, $roleText! This is your dashboard.',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
