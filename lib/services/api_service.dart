import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<Map<String, dynamic>> login(String id, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'password': password, 'role': role}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    }
    throw Exception('Login failed');
  }

  

  Future<void> markAttendance(String projectId, String date, List<String> absentStudents, List<int> periods, {bool isEdit = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/attendance/mark'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'projectId': projectId,
          'date': date,
          'absentStudents': absentStudents,
          'periods': periods,
          'isEdit': isEdit,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'Attendance marked successfully') {
          return;
        }
        throw Exception(responseData['message'] ?? 'Failed to mark attendance');
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Invalid request');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 404) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Resource not found');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to mark attendance');
      }
    } catch (e) {
      print('Error in markAttendance: $e');
      if (e is Exception) {
        throw e;
      }
      throw Exception('Failed to mark attendance. Please try again.');
    }
  }

  Future<Attendance> getStudentAttendance(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/attendance/student/$studentId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return Attendance.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to fetch attendance');
  }

  Future<List<Map<String, String>>> getStudentsByProjectId(String projectId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse('$baseUrl/attendance/students/$projectId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((student) => {
          'studentId': student['studentId'] as String,
          'name': student['name'] as String,
        }).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to fetch students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getStudentsByProjectId: $e');
      throw Exception('Failed to fetch students. Please try again.');
    }
  }

  Future<Map<String, dynamic>?> getAttendanceForDate(String projectId, String date) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/attendance/check?projectId=$projectId&date=$date'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAttendanceDetails(String projectId, String date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse('$baseUrl/attendance/details?projectId=$projectId&date=$date'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch attendance details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAttendanceDetails: $e');
      throw Exception('Failed to fetch attendance details. Please try again.');
    }
  }
}
