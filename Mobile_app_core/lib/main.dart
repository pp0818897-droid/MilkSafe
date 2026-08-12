import 'package:flutter/material.dart';

import 'FarmerRegistrationForm.dart';
import 'Vet_Register.dart';

void main() {
  runApp(const MilkSafeApp());
}

class MilkSafeApp extends StatelessWidget {
  const MilkSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MilkSafe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: const RoleSelectionPage(),
    );
  }
}

// ============================================================
// ROLE SELECTION
// ============================================================

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6F00),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'MilkSafe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(Icons.local_drink, size: 80, color: Color(0xFF2E7D32)),

              const SizedBox(height: 20),

              const Text(
                'Welcome to MilkSafe',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Please select your role',
                style: TextStyle(fontSize: 17, color: Colors.black54),
              ),

              const SizedBox(height: 40),

              // =================================================
              // FARMER
              // =================================================
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton.icon(
                  icon: const Icon(Icons.agriculture),

                  label: const Text(
                    'I am a Farmer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const FarmerRegistrationForm(tempToken: ''),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // =================================================
              // VETERINARIAN
              // =================================================
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton.icon(
                  icon: const Icon(Icons.medical_services),

                  label: const Text(
                    'I am a Veterinarian',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6F00),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VetForm()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'MilkSafe - Safe & Traceable Dairy System',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
