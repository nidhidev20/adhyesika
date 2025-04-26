import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  Future<void> login(String id, String password, String role) async {
    try {
      final data = await ApiService().login(id, password, role);
      _user = User.fromJson(data['user']);
      _token = data['token'];
      // Store token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!); // Use a distinct key
      notifyListeners();
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      _user = null;
      _token = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token'); // Match the key used in login
      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
      // Handle error gracefully, e.g., notify user or retry
    }
  }
}