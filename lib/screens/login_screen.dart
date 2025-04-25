import 'package:flutter/material.dart';

import 'admin_screen.dart';
import 'student_screen.dart';
import 'teacher/teacher_attendance_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Map<String, Map<String, String>> users = {
    'teacher1': {'role': 'Teacher', 'password': 'pass123'},
    'student1': {'role': 'Student', 'password': 'pass123'},
    'admin': {'role': 'Admin', 'password': 'admin123'},
  };

  void _login() {
    String username = usernameController.text;
    String password = passwordController.text;
    if (users.containsKey(username) && users[username]!['password'] == password) {
      String role = users[username]!['role']!;
      Widget nextScreen;
      switch (role) {
        case 'Teacher':
          nextScreen = const TeacherAttendanceView(role: 'Teacher');
          break;
        case 'Student':
          nextScreen = StudentScreen();
          break;
        case 'Admin':
          nextScreen = const AdminScreen();
          break;
        default:
          return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Username or Password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Enter Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Enter Password'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}