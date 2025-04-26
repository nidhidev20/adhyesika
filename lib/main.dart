import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/student_dashboard.dart';
import 'screens/faculty_dashboard.dart';
import 'screens/admin_dashboard.dart';
import 'screens/edit_attendance_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        initialRoute: '/auth',
        routes: {
          '/auth': (context) => LoginScreen(),
          '/student': (context) => StudentDashboard(),
          '/faculty': (context) => FacultyDashboard(),
          '/admin': (context) => AdminDashboard(),
          '/edit-attendance': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return EditAttendanceScreen(
              projectId: args['projectId'] as String,
              date: args['date'] as String,
              periods: args['periods'] as List<int>,
            );
          },
        },
      ),
    );
  }
}