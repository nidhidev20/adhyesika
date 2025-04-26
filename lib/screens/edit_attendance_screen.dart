import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditAttendanceScreen extends StatefulWidget {
  final String projectId;
  final String date;
  final List<int> periods;

  EditAttendanceScreen({
    required this.projectId,
    required this.date,
    required this.periods,
  });

  @override
  _EditAttendanceScreenState createState() => _EditAttendanceScreenState();
}

class _EditAttendanceScreenState extends State<EditAttendanceScreen> {
  List<String> absentStudents = [];
  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? attendanceData;
  List<Map<String, dynamic>> allStudents = [];
  int retryCount = 0;
  static const int maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      print('Fetching data for:');
      print('Project ID: ${widget.projectId}');
      print('Date: ${widget.date}');
      print('Periods: ${widget.periods}');

      // First, fetch all students for the project
      print('Fetching students...');
      final students = await ApiService().getStudentsByProjectId(widget.projectId);
      print('Fetched students: $students');
      
      if (students.isEmpty) {
        setState(() {
          errorMessage = 'No students found for this project';
          isLoading = false;
        });
        return;
      }

      setState(() {
        allStudents = students;
      });

      // Format the date to YYYY-MM-DD
      final dateParts = widget.date.split('T')[0].split('-');
      final formattedDate = '${dateParts[0]}-${dateParts[1]}-${dateParts[2]}';
      print('Formatted date for API: $formattedDate');

      // First verify attendance exists using getAttendanceForDate
      print('Verifying attendance exists...');
      final attendanceCheck = await ApiService().getAttendanceForDate(
        widget.projectId,
        formattedDate,
      );
      print('Attendance check response: $attendanceCheck');

      if (attendanceCheck == null) {
        setState(() {
          errorMessage = 'No attendance record found for this date';
          isLoading = false;
        });
        return;
      }

      // Then fetch attendance details
      print('Fetching attendance details...');
      final data = await ApiService().getAttendanceDetails(widget.projectId, formattedDate);
      print('Received attendance data: $data');
      
      if (data == null) {
        setState(() {
          errorMessage = 'No attendance details found for this date';
          isLoading = false;
        });
        return;
      }

      // Verify that the requested periods exist in the attendance data
      final availablePeriods = data['periods']?.keys.map(int.parse).toList() ?? [];
      final missingPeriods = widget.periods.where((period) => !availablePeriods.contains(period)).toList();
      
      if (missingPeriods.isNotEmpty) {
        setState(() {
          errorMessage = 'Some selected periods (${missingPeriods.join(', ')}) are not found in the attendance record';
          isLoading = false;
        });
        return;
      }

      setState(() {
        attendanceData = data;
        // Initialize absent students from all selected periods
        Set<String> allAbsentStudents = {};
        for (var period in widget.periods) {
          final periodData = data['periods'][period.toString()];
          if (periodData != null && periodData['absent'] != null) {
            final periodAbsentStudents = List<String>.from(
              periodData['absent'].map((s) => s['studentId'])
            );
            allAbsentStudents.addAll(periodAbsentStudents);
          }
        }
        absentStudents = allAbsentStudents.toList();
        print('Initialized ${absentStudents.length} absent students from all selected periods');
        isLoading = false;
        retryCount = 0; // Reset retry count on successful fetch
      });
    } catch (e) {
      print('Error in _fetchData: $e');
      retryCount++;
      setState(() {
        if (retryCount >= maxRetries) {
          errorMessage = 'Failed to load data after $maxRetries attempts. Please try again later.';
        } else {
          errorMessage = 'Failed to load data. Attempt $retryCount of $maxRetries.';
        }
        isLoading = false;
      });
    }
  }

  void _handleRetry() {
    if (retryCount < maxRetries) {
      _fetchData();
    } else {
      // Reset retry count and try again
      setState(() {
        retryCount = 0;
      });
      _fetchData();
    }
  }

  void _submitAttendance() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Format the date to YYYY-MM-DD
      final dateParts = widget.date.split('T')[0].split('-');
      final formattedDate = '${dateParts[0]}-${dateParts[1]}-${dateParts[2]}';

      await ApiService().markAttendance(
        widget.projectId,
        formattedDate,
        absentStudents,
        widget.periods,
        isEdit: true,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Attendance updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      print('Error updating attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update attendance. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Edit Attendance')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading data...'),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Edit Attendance')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleRetry,
                child: Text(retryCount >= maxRetries ? 'Try Again' : 'Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (allStudents.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Edit Attendance')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No students available'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleRetry,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Edit Attendance')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: ${widget.date.split('T')[0]}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Periods: ${widget.periods.join(', ')}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Total Students: ${allStudents.length}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Absent Students: ${absentStudents.length}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: allStudents.length,
              itemBuilder: (context, index) {
                final student = allStudents[index];
                final studentId = student['studentId'];
                final isAbsent = absentStudents.contains(studentId);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isAbsent) {
                        absentStudents.remove(studentId);
                      } else {
                        absentStudents.add(studentId);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isAbsent ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          student['name'] ?? studentId,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          studentId,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitAttendance,
        child: Icon(Icons.check),
      ),
    );
  }
} 