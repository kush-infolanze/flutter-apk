import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

// Screens
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/dealer_dashboard.dart';
import 'screens/distributor_dashboard.dart';
import 'screens/technician_dashboard.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Role-Based Auth System',
      theme: ThemeData(primarySwatch: Colors.blue),

      // ✅ Define all routes
      routes: {
        '/signin': (_) => const SignInScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/admin': (_) => const AdminDashboard(),
        '/dealer': (_) => const DealerDashboard(),
        '/distributor': (_) => const DistributorDashboard(),
        '/technician': (_) => const TechnicianDashboard(),
      },

      // ✅ Default route
      initialRoute: '/signin',
    );
  }
}
