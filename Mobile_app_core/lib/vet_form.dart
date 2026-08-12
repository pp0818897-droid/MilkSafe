import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class VetForm extends StatefulWidget {
  const VetForm({super.key});

  @override
  State<VetForm> createState() => _VetFormState();
}

class _VetFormState extends State<VetForm> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ================= FILE PICKER =================
  Future<void> pickDocument() async {
    final result = await FilePicker.pickFiles();

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected: ${result.files.single.name}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6F00),
        title: const Text("Veterinarian Registration"),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),

      body: FadeTransition(
        opacity: fadeAnim,

        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: ListView(
            children: [
              section("Personal Details"),

              input("Name"),
              input("Age"),
              input("Gender"),
              input("Address"),

              section("Professional Details"),

              input("Years of Experience"),

              input("Specialization (Dairy / Goat / Poultry / General)"),

              input("Clinic/Hospital Name"),

              input("Clinic Address + GPS"),

              section("Verification Documents"),

              input("Government Registration Number"),

              input("License Validity Date"),

              upload("Photo ID (Aadhar/PAN)"),

              upload("Self Photo"),

              section("Digital Information"),

              input("Email ID"),
              input("Password"),
              input("PIN"),

              const SizedBox(height: 30),

              Center(
                child: Image.asset(
                  "assets/images/submit.png",
                  height: 70,

                  // Prevents the app from crashing
                  // if the asset is missing.
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.upload_file,
                      size: 70,
                      color: Color(0xFFFF6F00),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Registration submitted")),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),

                child: const Text(
                  "SUBMIT REGISTRATION",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SECTION =================
  Widget section(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),

      child: Text(
        text,

        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }

  // ================= INPUT =================
  Widget input(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: TextField(
        decoration: InputDecoration(
          filled: true,

          fillColor: Colors.white,

          labelText: label,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ================= UPLOAD =================
  Widget upload(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(label),

          const SizedBox(height: 8),

          InkWell(
            onTap: pickDocument,

            child: Container(
              height: 55,

              decoration: BoxDecoration(
                color: Colors.white,

                border: Border.all(color: const Color(0xFFFF6F00)),

                borderRadius: BorderRadius.circular(12),
              ),

              child: const Center(
                child: Text(
                  "Upload Document",

                  style: TextStyle(
                    color: Color(0xFFFF6F00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
