import 'package:flutter/material.dart';

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