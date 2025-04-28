import 'package:flutter/material.dart';
import 'package:fluttering/admin/forms.dart';
import 'package:fluttering/attendance/mark_attendance.dart';

class FlutterApp extends StatelessWidget {
  const FlutterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AdminDashboard());
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final ValueNotifier<bool> _dark = ValueNotifier<bool>(true);
  final ValueNotifier<double> _widthFactor = ValueNotifier<double>(1.0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _dark,
      builder: (context, color, child) {
        return ValueListenableBuilder<double>(
          valueListenable: _widthFactor,
          builder: (context, factor, child) {
            return Scaffold(
              backgroundColor: _dark.value ? Colors.black : Colors.white,
              appBar: AppBar(
                title: const Text('Admin Dashboard'),
                backgroundColor: _dark.value ? Colors.grey[900] : Colors.blue,
                actions: [
                  Switch(
                    value: _dark.value,
                    onChanged: (value) {
                      _dark.value = value;
                    },
                  ),
                ],
              ),
              body: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width:
                          MediaQuery.of(context).size.width *
                          _widthFactor.value,
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.minWidth,
                            minHeight: 850,
                          ),
                          child: const Iphone1415ProMax38(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class Iphone1415ProMax38 extends StatelessWidget {
  const Iphone1415ProMax38({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final scaleFactor = screenWidth / 430;

        return SizedBox(
          width: screenWidth,
          height: 850 * scaleFactor,
          child: Stack(
            children: [
              // "← Admin Dashboard" text
              Positioned(
                left: 19 * scaleFactor,
                top: 66 * scaleFactor,
                child: Text(
                  '← Admin Dashboard',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24 * scaleFactor,
                    fontFamily: 'Inter',
                    height: 0,
                  ),
                ),
              ),

              // Mark Attendance (Clickable)
              Positioned(
                left: 25 * scaleFactor,
                top: 156 * scaleFactor,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MarkAttendance()),
                    );
                  },
                  child: Container(
                    width: screenWidth - 50 * scaleFactor,
                    height: 191 * scaleFactor,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E5879),
                      borderRadius: BorderRadius.circular(20 * scaleFactor),
                    ),
                    child: Center(
                      child: Text(
                        'Mark Attendance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24 * scaleFactor,
                          fontFamily: 'Inter',
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Edit Attendance (Clickable)
              Positioned(
                left: 25 * scaleFactor,
                top: 385 * scaleFactor,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MarkAttendance()),
                    );
                  },
                  child: Container(
                    width: screenWidth - 50 * scaleFactor,
                    height: 191 * scaleFactor,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E5879),
                      borderRadius: BorderRadius.circular(20 * scaleFactor),
                    ),
                    child: Center(
                      child: Text(
                        'Edit Attendance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24 * scaleFactor,
                          fontFamily: 'Inter',
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Forms (Clickable)
              Positioned(
                left: 25 * scaleFactor,
                top: 607 * scaleFactor,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CreateForm()),
                    );
                  },
                  child: Container(
                    width: screenWidth - 50 * scaleFactor,
                    height: 191 * scaleFactor,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E5879),
                      borderRadius: BorderRadius.circular(20 * scaleFactor),
                    ),
                    child: Center(
                      child: Text(
                        'Forms',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24 * scaleFactor,
                          fontFamily: 'Inter',
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Decorative rotated boxes (unchanged)
              ...[
                Positioned(
                  left: 411.96 * scaleFactor,
                  top: 22 * scaleFactor,
                  child: Transform.rotate(
                    angle: 0.47,
                    child: _decorativeBox(scaleFactor),
                  ),
                ),
                Positioned(
                  left: -109.77 * scaleFactor,
                  top: 829 * scaleFactor,
                  child: Transform.rotate(
                    angle: 0.11,
                    child: _decorativeBox(scaleFactor),
                  ),
                ),
                Positioned(
                  left: -104.04 * scaleFactor,
                  top: 674 * scaleFactor,
                  child: Transform.rotate(
                    angle: 0.47,
                    child: _decorativeBox(scaleFactor),
                  ),
                ),
                Positioned(
                  left: 164.33 * scaleFactor,
                  top: 867 * scaleFactor,
                  child: Transform.rotate(
                    angle: 0.94,
                    child: _decorativeBox(scaleFactor),
                  ),
                ),
                Positioned(
                  left: 278 * scaleFactor,
                  top: -49.34 * scaleFactor,
                  child: Transform.rotate(
                    angle: -0.32,
                    child: _decorativeBox(scaleFactor),
                  ),
                ),
                Positioned(
                  left: 157 * scaleFactor,
                  top: -104.02 * scaleFactor,
                  child: Transform.rotate(
                    angle: -0.35,
                    child: _decorativeBox(scaleFactor),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _decorativeBox(double scaleFactor) {
    return SizedBox(
      width: 236 * scaleFactor,
      height: 181 * scaleFactor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xBC3E5879),
          borderRadius: BorderRadius.circular(20 * scaleFactor),
        ),
      ),
    );
  }
}
