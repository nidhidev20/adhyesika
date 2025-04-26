import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StudentSelectionScreen extends StatefulWidget {
  final String projectId;
  final String date;
  final List<int> periods;
  final bool isEditMode;

  StudentSelectionScreen({
    required this.projectId,
    required this.date,
    required this.periods,
    required this.isEditMode,
  });

  @override
  _StudentSelectionScreenState createState() => _StudentSelectionScreenState();
}

class _StudentSelectionScreenState extends State<StudentSelectionScreen> {
  List<Map<String, String>> students = [];
  List<String> absentStudents = [];
  bool isLoading = true;
  String? errorMessage;

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

      // Fetch students
      final fetchedStudents = await ApiService().getStudentsByProjectId(widget.projectId);
      
      if (fetchedStudents.isEmpty) {
        setState(() {
          errorMessage = 'No students found for this project';
          isLoading = false;
        });
        return;
      }

      setState(() {
        students = fetchedStudents;
      });

      // If in edit mode, fetch existing attendance data
      if (widget.isEditMode) {
        final attendanceDetails = await ApiService().getAttendanceDetails(widget.projectId, widget.date);
        
        if (attendanceDetails == null) {
          setState(() {
            errorMessage = 'No attendance record found for this date';
            isLoading = false;
          });
          return;
        }

        // Initialize absent students from all selected periods
        Set<String> allAbsentStudents = {};
        for (var period in widget.periods) {
          final periodData = attendanceDetails['periods'][period.toString()];
          if (periodData != null && periodData['absent'] != null) {
            final periodAbsentStudents = List<String>.from(
              periodData['absent'].map((s) => s['studentId'])
            );
            allAbsentStudents.addAll(periodAbsentStudents);
          }
        }
        setState(() {
          absentStudents = allAbsentStudents.toList();
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        errorMessage = 'Failed to load data. Please try again.';
        isLoading = false;
      });
    }
  }

  void _submitAttendance() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // First verify the periods are not already marked (for new attendance)
      if (!widget.isEditMode) {
        final attendanceCheck = await ApiService().getAttendanceForDate(
          widget.projectId,
          widget.date,
        );

        if (attendanceCheck != null) {
          final markedPeriods = attendanceCheck['markedPeriods'] ?? [];
          final alreadyMarked = widget.periods.where((period) => markedPeriods.contains(period)).toList();
          
          if (alreadyMarked.isNotEmpty) {
            throw Exception('Periods ${alreadyMarked.join(', ')} have already been marked. Please try again.');
          }
        }
      }

      // Mark/Edit the attendance
      await ApiService().markAttendance(
        widget.projectId,
        widget.date,
        absentStudents,
        widget.periods,
        isEdit: widget.isEditMode,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isEditMode ? 'Attendance updated successfully' : 'Attendance marked successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Wait for the snackbar to show before navigating
      await Future.delayed(Duration(seconds: 2));
      
      // Navigate back to faculty dashboard
      Navigator.popUntil(context, ModalRoute.withName('/faculty'));
    } catch (e) {
      print('Error ${widget.isEditMode ? 'updating' : 'marking'} attendance: $e');
      String errorMessage = 'Failed to ${widget.isEditMode ? 'update' : 'mark'} attendance. Please try again.';
      
      if (e.toString().contains('already been marked')) {
        errorMessage = e.toString();
      } else if (e.toString().contains('Authentication failed')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (e.toString().contains('No attendance record found')) {
        errorMessage = 'No attendance record found to edit. Please mark attendance first.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
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
        appBar: AppBar(title: Text('Select Students')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading students...'),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Select Students')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchData,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (students.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Select Students')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No students found for this project'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchData,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Select Students')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: ${widget.date}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Periods: ${widget.periods.join(', ')}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Select ${widget.isEditMode ? 'absent' : 'present/absent'} students:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1.0,
              ),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final studentId = student['studentId']!;
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
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          studentId.substring(studentId.length - 3),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
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