import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/simple_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController(); // ✅ added
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Add role dropdown
  final List<String> roles = ['admin', 'dealer', 'distributor', 'technician'];
  String selectedRole = 'dealer';

  // Updated register method
  void _register(BuildContext context) async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please fill in all fields.')),
      );
      return;
    }

    try {
      await Provider.of<AuthProvider>(context, listen: false).signUp(
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        usernameController.text.trim(), // ✅ added username
        emailController.text.trim(),
        passwordController.text.trim(),
        selectedRole, // include role
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Sign up successful! Please sign in.')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("⚠️ ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SimpleTextField(controller: firstNameController, label: "First Name"),
              const SizedBox(height: 12),
              SimpleTextField(controller: lastNameController, label: "Last Name"),
              const SizedBox(height: 12),
              SimpleTextField(controller: usernameController, label: "Username"), // ✅ added
              const SizedBox(height: 12),
              SimpleTextField(controller: emailController, label: "Email"),
              const SizedBox(height: 12),
              SimpleTextField(
                controller: passwordController,
                label: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // 🔽 Role dropdown
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Select Role',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRole,
                    isExpanded: true,
                    items: roles
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _register(context),
                  child: const Text("Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
