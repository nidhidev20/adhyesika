import 'package:flutter/material.dart';

import 'student/student_profile_screen.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: const StudentProfileScreen(),
    );
  }
}