import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/simple_text_field.dart';
import 'signup_screen.dart';
import 'admin_dashboard.dart';
import 'dealer_dashboard.dart';
import 'distributor_dashboard.dart';
import 'technician_dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void _login(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill in all fields.")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .signIn(emailController.text.trim(), passwordController.text.trim());

      final auth = Provider.of<AuthProvider>(context, listen: false);
      final user = auth.user;
      final role = user?['role'];

      // 🧭 Navigate based on user role
      Widget nextScreen;
      switch (role) {
        case 'admin':
          nextScreen = const AdminDashboard();
          break;
        case 'dealer':
          nextScreen = const DealerDashboard();
          break;
        case 'distributor':
          nextScreen = const DistributorDashboard();
          break;
        case 'technician':
          nextScreen = const TechnicianDashboard();
          break;
        default:
          nextScreen = const Scaffold(
              body: Center(child: Text("❌ Unknown user role.")));
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("⚠️ ${e.toString()}")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SimpleTextField(controller: emailController, label: "Email"),
              const SizedBox(height: 12),
              SimpleTextField(
                  controller: passwordController,
                  label: "Password",
                  obscureText: true),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _login(context),
                      child: const Text("Sign In"),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  );
                },
                child: const Text("Don’t have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
