import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user_role.dart';
import '../services/api_config.dart';
import '../services/token_storage.dart';
import '../farmer_dashboard.dart';
import '../VetDashboard.dart';

class RoleSignup extends StatefulWidget {
  final UserRole role;

  const RoleSignup({
    super.key,
    required this.role,
  });

  @override
  State<RoleSignup> createState() => _RoleSignupState();
}

class _RoleSignupState extends State<RoleSignup> {
  final _formKey = GlobalKey<FormState>();

  // Common controllers
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  // Farmer fields
  final _farmNameCtrl = TextEditingController();
  final _farmAddressCtrl = TextEditingController();
  final _farmMobileCtrl = TextEditingController();

  // Veterinarian fields
  final _vetPhoneCtrl = TextEditingController();
  final _vetQualificationCtrl = TextEditingController();
  String? _vetSpecialization;
  final List<String> _vetSpecializations = [
    'Veterinary Medicine',
    'Large Animal Medicine',
    'Dairy Animal Health',
    'Veterinary Surgery',
    'Other',
  ];

  // Authority fields
  final _orgNameCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();
  final _authorityPhoneCtrl = TextEditingController();
  final _officeAddressCtrl = TextEditingController();

  // Terms checkbox
  bool _termsAccepted = false;

  int get _strength {
    var score = 0;
    final pwd = _passwordCtrl.text;
    if (pwd.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(pwd)) score++;
    if (RegExp(r'[0-9]').hasMatch(pwd)) score++;
    if (RegExp(r'[!@#\$%^&*]').hasMatch(pwd)) score++;
    return score;
  }

  String get _strengthLabel {
    switch (_strength) {
      case 0:
      case 1:
        return 'Too weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  bool get _isPasswordValid => _strength == 4;

  bool get _isFormValid {
    if (_nameCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        !_isPasswordValid ||
        _passwordCtrl.text != _confirmPasswordCtrl.text ||
        !_termsAccepted) {
      return false;
    }
    switch (widget.role) {
      case UserRole.farmer:
        return _farmNameCtrl.text.isNotEmpty &&
            _farmAddressCtrl.text.isNotEmpty &&
            _farmMobileCtrl.text.isNotEmpty;
      case UserRole.veterinarian:
        return _vetPhoneCtrl.text.isNotEmpty &&
            _vetQualificationCtrl.text.isNotEmpty &&
            _vetSpecialization != null;
      case UserRole.authority:
        return _orgNameCtrl.text.isNotEmpty &&
            _designationCtrl.text.isNotEmpty &&
            _authorityPhoneCtrl.text.isNotEmpty &&
            _officeAddressCtrl.text.isNotEmpty;
      case UserRole.consumer:
        return true;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _farmNameCtrl.dispose();
    _farmAddressCtrl.dispose();
    _farmMobileCtrl.dispose();
    _vetPhoneCtrl.dispose();
    _vetQualificationCtrl.dispose();
    _orgNameCtrl.dispose();
    _designationCtrl.dispose();
    _authorityPhoneCtrl.dispose();
    _officeAddressCtrl.dispose();
    super.dispose();
  }

  // Handles signup by calling backend and navigating to appropriate dashboard
  Future<void> _handleSignup() async {
    final baseUrl = ApiConfig.baseUrl;
    final payload = {
      "name": _nameCtrl.text,
      "email": _emailCtrl.text,
      "password": _passwordCtrl.text,
      "role": widget.role.toString().split('.').last,
    };
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["status"] == "success") {
          final token = decoded["data"]["access_token"];
          await TokenStorage.saveToken(token);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully')),
          );
          if (widget.role == UserRole.farmer) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FarmerDashboard()),
            );
          } else if (widget.role == UserRole.veterinarian) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => VetDashboard(vetToken: token)),
            );
          } else {
            // Authority or Consumer – stay on page (no dedicated dashboard)
          }
          return;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${response.body}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration error: $e')),
      );
    }
  }

  String _roleHeader() {
    switch (widget.role) {
      case UserRole.farmer:
        return 'Create your Farmer account';
      case UserRole.veterinarian:
        return 'Create your Veterinarian account';
      case UserRole.authority:
        return 'Create your Authority account';
      case UserRole.consumer:
        return 'Create your Consumer account';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_roleHeader()),
        backgroundColor: colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full Name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter your full name' : null,
              ),
              const SizedBox(height: 12),
              // Email
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter your email' : null,
              ),
              const SizedBox(height: 12),
              // Password
              TextFormField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Strength: $_strengthLabel',
                style: TextStyle(color: _isPasswordValid ? Colors.green : Colors.redAccent),
              ),
              const SizedBox(height: 12),
              // Confirm Password
              TextFormField(
                controller: _confirmPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v != _passwordCtrl.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 20),
              // Role‑specific sections
              if (widget.role == UserRole.farmer) ...[
                TextFormField(
                  controller: _farmNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Farm Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _farmAddressCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Farm Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _farmMobileCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              if (widget.role == UserRole.veterinarian) ...[
                TextFormField(
                  controller: _vetPhoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _vetQualificationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Qualification',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                    border: OutlineInputBorder(),
                  ),
                  items: _vetSpecializations
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  value: _vetSpecialization,
                  onChanged: (v) => setState(() => _vetSpecialization = v),
                  validator: (v) => v == null ? 'Select a specialization' : null,
                ),
                const SizedBox(height: 20),
              ],

              if (widget.role == UserRole.authority) ...[
                TextFormField(
                  controller: _orgNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Organization / Department Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _designationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Designation',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _authorityPhoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Official Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _officeAddressCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Office Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Terms checkbox
              CheckboxListTile(
                title: const Text('I agree to the Terms of Service and Privacy Policy'),
                value: _termsAccepted,
                onChanged: (v) => setState(() => _termsAccepted = v ?? false),
              ),
              const SizedBox(height: 12),

              // Create Account button
              FilledButton(
                onPressed: _isFormValid ? _handleSignup : null,
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
