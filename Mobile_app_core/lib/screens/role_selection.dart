import 'package:flutter/material.dart';
import 'package:mobile_app_core/models/user_role.dart';
import 'role_signup.dart';

class RoleSelection extends StatefulWidget {
  const RoleSelection({super.key});

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  UserRole? _selectedRole;

  Widget _buildRoleCard({
    required UserRole role,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isSelected = _selectedRole == role;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _selectedRole = role),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role'),
        backgroundColor: colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Choose your role to continue',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildRoleCard(
                    role: UserRole.farmer,
                    icon: Icons.agriculture_rounded,
                    title: 'Farmer',
                    description: 'Manage your farm, animals and milk safety.',
                  ),
                  _buildRoleCard(
                    role: UserRole.veterinarian,
                    icon: Icons.medical_services_rounded,
                    title: 'Veterinarian',
                    description:
                        'Manage animal health, medicines and treatment records.',
                  ),
                  _buildRoleCard(
                    role: UserRole.authority,
                    icon: Icons.account_balance_rounded,
                    title: 'Authority',
                    description:
                        'Monitor milk safety, compliance and public health.',
                  ),
                  _buildRoleCard(
                    role: UserRole.consumer,
                    icon: Icons.person_rounded,
                    title: 'Consumer',
                    description:
                        'Track milk safety and verify product information.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _selectedRole == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RoleSignup(role: _selectedRole!),
                        ),
                      );
                    },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
