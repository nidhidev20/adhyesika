import 'package:flutter/material.dart';

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Attendance App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
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
          nextScreen = AttendanceScreen(role: 'Teacher');
          break;
        case 'Student':
          nextScreen = StudentScreen();
          break;
        case 'Admin':
          nextScreen = AdminScreen();
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

class AttendanceScreen extends StatefulWidget {
  final String role;
  const AttendanceScreen({super.key, required this.role});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Map<String, bool> students = {
    'Student 1': true,
    'Student 2': true,
    'Student 3': true,
    'Student 4': true,
    'Student 5': true,
    'Student 6': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double maxWidth = constraints.maxWidth;
                  int columns = (maxWidth ~/ 60).clamp(3, 8);
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: students.keys.map((student) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            students[student] = !students[student]!;
                          });
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: students[student]! ? Colors.green : Colors.red,
                          child: Text(
                            student,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      students.updateAll((key, value) => true);
                    });
                  },
                  child: const Text('Mark all PRESENT'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    setState(() {
                      students.updateAll((key, value) => false);
                    });
                  },
                  child: const Text('Mark all ABSENT'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Note: By default, all students are marked as present."),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Attendance Marked: $students');
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  Future<Map<String, dynamic>> fetchStudentData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating API delay
    return {
      "name": "Student1",
      "id": "1",
      "department": "department",
      "section": "section",
      "year": "year",
      "admissionYear": "20xx-xx",
      "attendance": 0.00,
      "sessions": {
        "Mon": [null, null, null, null],
        "Tues": [true, true, true, true],
        "Wed": [true, true, true, true],
        "Thurs": [false, false, false, false],
        "Fri": [true, true, true, true],
        "Sat": [true, true, true, true],
      },
      "summary": {"present": 50, "absent": 5, "noSessions": 22},
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Profile")),
      body: FutureBuilder(
        future: fetchStudentData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var student = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(radius: 50, backgroundColor: Colors.grey),
                const SizedBox(height: 10),
                Text(student["name"],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Text(student["id"]),
                const SizedBox(height: 10),
                _buildDetailRow("Department", student["department"]),
                _buildDetailRow("Section", student["section"]),
                _buildDetailRow("Current Year", student["year"].toString()),
                _buildDetailRow("Year of Admission", student["admissionYear"]),
                const SizedBox(height: 20),
                _buildAttendanceOverview(student),
                _buildQuickActions(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.blue)),
      ],
    );
  }

  Widget _buildAttendanceOverview(Map<String, dynamic> student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Attendance Overview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: student["attendance"] / 100,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 10),
            Text("${student["attendance"]}%",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        ...student["sessions"].entries.map((session) => ListTile(
          title: Text(session.key, style: const TextStyle(fontSize: 16)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: session.value.map<Widget>((attended) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Icon(
                  attended == true
                      ? Icons.check_circle
                      : Icons.remove_circle_outline,
                  color: attended == true ? Colors.green : Colors.grey,
                ),
              );
            }).toList(),
          ),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSummaryBox("Present", student["summary"]["present"], Colors.green),
            _buildSummaryBox("Absent", student["summary"]["absent"], Colors.red),
            _buildSummaryBox("No Sessions", student["summary"]["noSessions"], Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryBox(String label, int count, Color color) {
    return Column(
      children: [
        Text("$count",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }

  Widget _buildQuickActions() {
    List<Map<String, dynamic>> actions = [
      {"title": "Clubs", "icon": Icons.group},
      {"title": "Attendance", "icon": Icons.calendar_today},
      {"title": "Results", "icon": Icons.bar_chart},
      {"title": "Timetable", "icon": Icons.schedule},
      {"title": "QR", "icon": Icons.qr_code},
      {"title": "Feedback", "icon": Icons.feedback},
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: actions.map((action) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(action["icon"], color: Colors.blue),
              ),
              const SizedBox(height: 5),
              Text(action["title"], style: const TextStyle(fontSize: 12)),
            ],
          );
        }).toList(),
      ),
    );
  }
}


class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.add),
                            title: Text('Add Students'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddStudentScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit Students'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditStudentScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete Students'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DeleteStudentScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text('Manage Students'),
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.add),
                          title: Text('Add Teachers'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddStudentScreen()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit Teachers'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditStudentScreen()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete Teachers'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DeleteStudentScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
              },
              child: Text('Manage Teachers'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Forms'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Permissions'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddStudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Student')),
      body: Center(child: Text('Add New Student')),
    );
  }
}

class EditStudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Student')),
      body: Center(child: Text('Edit Students')),
    );
  }
}

class DeleteStudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delete Student')),
      body: Center(child: Text('Delete Students')),
    );
  }
}
