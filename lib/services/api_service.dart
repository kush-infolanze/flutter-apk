import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // static const String baseUrl = "http://localhost:5000/api";
  static const String baseUrl = "https://flutter-back.vercel.app/api";


  // ───────────────────────────────
  // 🔹 Helper: Get stored token
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ───────────────────────────────
  // 🔹 Signup
  Future<http.Response> signUp(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'), // matches backend route
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }

  // ───────────────────────────────
  // 🔹 Signin
  Future<http.Response> signIn(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'), // matches backend route
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }

  // ───────────────────────────────
  // 🔹 Get all users (Admin only)
  static Future<List<dynamic>> getAllUsers() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch users: ${response.body}");
    }
  }

  // ───────────────────────────────
  // 🔹 Add user (Admin only)
  static Future<void> addUser(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add user: ${response.body}");
    }
  }

  // ───────────────────────────────
  // 🔹 Update user (Admin only)
  static Future<void> updateUser(String id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update user: ${response.body}");
    }
  }

  // ───────────────────────────────
  // 🔹 Delete user (Admin only)
  static Future<void> deleteUser(String id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete user: ${response.body}");
    }
  }
}
