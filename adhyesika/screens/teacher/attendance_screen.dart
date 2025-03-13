import 'package:flutter/material.dart';

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