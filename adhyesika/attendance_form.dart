import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'attendance_screen.dart';

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