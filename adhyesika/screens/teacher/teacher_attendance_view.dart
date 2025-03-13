import 'package:flutter/material.dart';

import 'attendance_form.dart';

class TeacherAttendanceView extends StatelessWidget {
  final String role;
  const TeacherAttendanceView({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Attendance')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceForm(),
                ),
              ),
              child: const Text('Mark Attendance'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Edit Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}