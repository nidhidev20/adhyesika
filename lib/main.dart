import 'package:flutter/material.dart';

import 'admin_dashboard.dart';
import 'student_dashboard.dart';
import 'teacher_dashboard.dart';

void main() {
  runApp(FlutterApp());
}

class FlutterApp extends StatelessWidget {
  final ValueNotifier<bool> _dark = ValueNotifier<bool>(true);
  final ValueNotifier<double> _widthFactor = ValueNotifier<double>(1.0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomeScreen(dark: _dark, widthFactor: _widthFactor),
        '/admin': (context) => AdminScreen(),
        '/teacher': (context) => TeacherScreen(),
        '/student': (context) => StudentScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final ValueNotifier<bool> dark;
  final ValueNotifier<double> widthFactor;

  const HomeScreen({Key? key, required this.dark, required this.widthFactor})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: dark,
      builder: (context, color, child) {
        return ValueListenableBuilder<double>(
          valueListenable: widthFactor,
          builder: (context, factor, child) {
            return Scaffold(
              backgroundColor: dark.value ? Colors.black : Colors.white,
              appBar: AppBar(
                backgroundColor: dark.value ? Colors.black87 : Colors.white,
                foregroundColor: dark.value ? Colors.white : Colors.black,
                actions: [
                  Switch(
                    value: dark.value,
                    onChanged: (value) {
                      dark.value = value;
                    },
                  ),
                ],
              ),
              body: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * widthFactor.value,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ResponsiveLoginScreen(isDarkMode: dark.value)],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ResponsiveLoginScreen extends StatefulWidget {
  final bool isDarkMode;

  const ResponsiveLoginScreen({Key? key, required this.isDarkMode})
    : super(key: key);

  @override
  _ResponsiveLoginScreenState createState() => _ResponsiveLoginScreenState();
}

class _ResponsiveLoginScreenState extends State<ResponsiveLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;

  void _attemptLogin() {
    final String username = _usernameController.text.trim().toLowerCase();
    const String validPassword = "password123";

    if (_passwordController.text == validPassword) {
      setState(() {
        _errorMessage = null;
      });

      // Navigate based on username
      if (username == "admin") {
        Navigator.pushNamed(context, '/admin');
      } else if (username == "teacher") {
        Navigator.pushNamed(context, '/teacher');
      } else if (username == "student") {
        Navigator.pushNamed(context, '/student');
      } else {
        setState(() {
          _errorMessage = "Invalid username";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Invalid password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions
        final double maxWidth = constraints.maxWidth;
        final double containerWidth = maxWidth > 430 ? 430 : maxWidth;
        final double containerHeight =
            containerWidth * (932 / 430); // Keep original aspect ratio
        final double scale = containerWidth / 430; // Scale factor

        return Container(
          width: containerWidth,
          height: containerHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Original container
              Container(
                width: containerWidth,
                height: containerHeight,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: widget.isDarkMode ? Colors.black : Colors.white,
                ),
              ),

              // Calendar icon with dark mode support - smaller size and specific color
              Positioned(
                left: 8 * scale,
                top: 12 * scale,
                child: Container(
                  width: 413 * scale,
                  height: 438 * scale,
                  child: Center(
                    child: Icon(
                      Icons.calendar_today,
                      size: 200 * scale, // Smaller size
                      color: Color(0xFF5F99AE), // Specific shade as requested
                    ),
                  ),
                ),
              ),

              // Blue container for login area
              Positioned(
                left: 0,
                top: 441 * scale,
                child: Container(
                  width: containerWidth,
                  height: 628 * scale,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Color(0xFF3E5879),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Username field
                      Positioned(
                        left: 52 * scale,
                        top: 59 * scale,
                        child: Container(
                          width: 326 * scale,
                          height: 80 * scale,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 11 * scale,
                              right: 10 * scale,
                            ),
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Username',
                                hintStyle: TextStyle(
                                  color: Color(0xFF3E5879),
                                  fontSize: 20 * scale,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Password field
                      Positioned(
                        left: 52 * scale,
                        top: 180 * scale,
                        child: Container(
                          width: 326 * scale,
                          height: 80 * scale,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 14 * scale,
                              right: 10 * scale,
                            ),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Password',
                                hintStyle: TextStyle(
                                  color: Color(0xFF3E5879),
                                  fontSize: 20 * scale,
                                  fontFamily: 'Inter',
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Color(0xFF3E5879),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Login button
                      Positioned(
                        left: 127 * scale,
                        top: 301 * scale,
                        child: GestureDetector(
                          onTap: _attemptLogin,
                          child: Container(
                            width: 175 * scale,
                            height: 50 * scale,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xFF3E5879),
                                  fontSize: 20 * scale,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Forget Password text
                      Positioned(
                        left: 151 * scale,
                        top: 392 * scale,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Password reset functionality would go here',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Forget Password ?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15 * scale,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),

                      // Error message if login fails
                      if (_errorMessage != null)
                        Positioned(
                          left: 127 * scale,
                          top: 355 * scale,
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red[300],
                              fontSize: 15 * scale,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Decorative blue containers (transformed)
              Positioned(
                left: 119 * scale,
                top: -85.32 * scale,
                child: Transform(
                  transform:
                      Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(-0.52),
                  child: Container(
                    width: 196 * scale,
                    height: 211 * scale,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0xBC3E5879),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),

              // Welcome text
              Positioned(
                left: 21 * scale,
                top: 316 * scale,
                child: Text(
                  'Welcome To',
                  style: TextStyle(
                    color: Color(0xFF3E5879),
                    fontSize: 36 * scale,
                    fontFamily: 'Inter',
                  ),
                ),
              ),

              // KMIT text
              Positioned(
                left: 21 * scale,
                top: 360 * scale,
                child: Text(
                  'Adhyesika-KMIT',
                  style: TextStyle(
                    color: Color(0xFF3E5879),
                    fontSize: 40 * scale,
                    fontFamily: 'Inter',
                  ),
                ),
              ),

              // More decorative elements
              Positioned(
                left: 228 * scale,
                top: -42.85 * scale,
                child: Transform(
                  transform:
                      Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(-0.29),
                  child: Container(
                    width: 199 * scale,
                    height: 198 * scale,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0xBC3E5879),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 357 * scale,
                top: 256.52 * scale,
                child: Transform(
                  transform:
                      Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(-0.96),
                  child: Container(
                    width: 167.13 * scale,
                    height: 179.28 * scale,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0xBC3E5879),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 315 * scale,
                top: 162.55 * scale,
                child: Transform(
                  transform:
                      Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(-0.96),
                  child: Container(
                    width: 199 * scale,
                    height: 198 * scale,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0xBC3E5879),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// Admin Screen

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Color(0xFF3E5879),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.admin_panel_settings,
              size: 100,
              color: Color(0xFF3E5879),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E5879),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This is the admin dashboard',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDashboard()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3E5879),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('continue', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// Teacher Screen
class TeacherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Portal'),
        backgroundColor: Color(0xFF5F99AE),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 100, color: Color(0xFF5F99AE)),
            SizedBox(height: 20),
            Text(
              'Welcome, Teacher!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5F99AE),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This is the teacher portal',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherDashboard()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3E5879),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('continue', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// Student Screen
class StudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Portal'),
        backgroundColor: Color(0xFF3E5879),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100, color: Color(0xFF3E5879)),
            SizedBox(height: 20),
            Text(
              'Welcome, Student!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E5879),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This is the student portal',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentDashboard()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3E5879),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('continue', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
