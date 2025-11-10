import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // ✅ Access map keys safely
    final user = auth.user ?? {};
    final firstName = user['firstName'] ?? '';
    final role = user['role'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, $firstName"),
        actions: [
          IconButton(
            onPressed: () {
              auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("✅ You are logged in successfully!"),
            const SizedBox(height: 12),
            Text("Your role: ${role.toUpperCase()}"),
          ],
        ),
      ),
    );
  }
}
