import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _token;

  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  // ────────────── Sign Up ──────────────
  Future<void> signUp(String first, String last, String email,String username, String pass, String role) async {
    final res = await ApiService().signUp({
      "firstName": first,
      "lastName": last,
      "username": email,
      "email": username,
      "password": pass,
      "role": role,
    });

    if (res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)['message'] ?? "Sign up failed");
    }
  }

  // ────────────── Sign In ──────────────
  Future<void> signIn(String username, String password) async {
    final res = await ApiService().signIn({
      "email": username,
      "password": password,
    });

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message'] ?? "Invalid credentials");
    }

    final data = jsonDecode(res.body);
    _token = data['token'];
    _user = data['user'];

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _token!);
    prefs.setString('user', jsonEncode(_user!));

    notifyListeners();
  }

  // ────────────── Logout ──────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    _token = null;
    notifyListeners();
  }

  // ────────────── Auto Login (optional) ──────────────
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return;
    _token = prefs.getString('token');
    _user = jsonDecode(prefs.getString('user') ?? "{}");
    notifyListeners();
  }
}
