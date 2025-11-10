import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final data = await ApiService.getAllUsers();
      setState(() {
        users = data;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetching users: $e")));
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteUser(String id) async {
    try {
      await ApiService.deleteUser(id);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User deleted")));
      _fetchUsers();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error deleting user: $e")));
    }
  }

  Future<void> _showUserDialog({Map<String, dynamic>? existingUser}) async {
    final firstNameController = TextEditingController(text: existingUser?['firstName'] ?? '');
    final lastNameController = TextEditingController(text: existingUser?['lastName'] ?? '');
    final usernameController = TextEditingController(text: existingUser?['username'] ?? '');
    final emailController = TextEditingController(text: existingUser?['email'] ?? '');
    final passwordController = TextEditingController();
    String role = existingUser?['role'] ?? 'user';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingUser == null ? "Add User" : "Edit User"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "First Name")),
                TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "Last Name")),
                TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Username")),
                TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
                if (existingUser == null)
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: role,
                  items: ['admin', 'dealer', 'distributor', 'technician', 'user']
                      .map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase())))
                      .toList(),
                  onChanged: (val) => role = val!,
                  decoration: const InputDecoration(labelText: "Role"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (existingUser == null) {
                    await ApiService.addUser({
                      "firstName": firstNameController.text.trim(),
                      "lastName": lastNameController.text.trim(),
                      "username": usernameController.text.trim(),
                      "email": emailController.text.trim(),
                      "password": passwordController.text.trim(),
                      "role": role,
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("✅ User added")));
                  } else {
                    await ApiService.updateUser(existingUser['_id'], {
                      "firstName": firstNameController.text.trim(),
                      "lastName": lastNameController.text.trim(),
                      "username": usernameController.text.trim(),
                      "email": emailController.text.trim(),
                      "role": role,
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("✅ User updated")));
                  }

                  Navigator.pop(context);
                  _fetchUsers();
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("⚠️ Error: $e")));
                }
              },
              child: Text(existingUser == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(),
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchUsers,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text("${user['firstName']} ${user['lastName']}"),
                      subtitle: Text("${user['email']} • ${user['role']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showUserDialog(existingUser: user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user['_id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
