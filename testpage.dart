import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          nextScreen = TeacherAttendanceView(role: 'Teacher');
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

class AttendanceForm extends StatefulWidget {
  const AttendanceForm({super.key});

  @override
  _AttendanceFormState createState() => _AttendanceFormState();
}

class _AttendanceFormState extends State<AttendanceForm> {
  DateTime selectedDate = DateTime.now();
  String? selectedHour;
  String? selectedYear;
  String? selectedClass;

  final List<String> hours = [
    '1st Hour', '2nd Hour', '3rd Hour', '4th Hour',
    '5th Hour', '6th Hour', '7th Hour'
  ];

  final List<String> years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  final List<String> subjects = ['Subject 1', 'Subject 2', 'Subject 3', 'Subject 4']; // Replace with actual assigned subjects

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Hour'),
              value: selectedHour,
              items: hours.map((hour) => DropdownMenuItem(value: hour, child: Text(hour))).toList(),
              onChanged: (value) => setState(() => selectedHour = value),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Year'),
              value: selectedYear,
              items: years.map((year) => DropdownMenuItem(value: year, child: Text(year))).toList(),
              onChanged: (value) => setState(() => selectedYear = value),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Class'),
              value: selectedClass,
              items: subjects.map((subject) => DropdownMenuItem(value: subject, child: Text(subject))).toList(),
              onChanged: (value) => setState(() => selectedClass = value),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedHour != null && selectedYear != null && selectedClass != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AttendanceScreen(role: 'Teacher')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: const Text('Submit'),
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Attendance saved successfully')),
          );
          Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: const StudentProfileScreen(),
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
    return FutureBuilder(
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
              const CircleAvatar(radius: 50, backgroundColor: Colors.grey),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Actions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(Icons.calendar_today, "View Calendar"),
            _buildActionButton(Icons.schedule, "Request Leave"),
            _buildActionButton(Icons.assessment, "Full Report"),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildAdminCard(
              'Manage Users',
              Icons.people,
              Colors.blue,
                  () {},
            ),
            _buildAdminCard(
              'Attendance Reports',
              Icons.bar_chart,
              Colors.green,
                  () {},
            ),
            _buildAdminCard(
              'Class Management',
              Icons.class_,
              Colors.orange,
                  () {},
            ),
            _buildAdminCard(
              'System Settings',
              Icons.settings,
              Colors.purple,
                  () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}