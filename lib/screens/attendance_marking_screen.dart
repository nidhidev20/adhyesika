import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'student_selection_screen.dart';

class AttendanceMarkingScreen extends StatefulWidget {
  final bool isEditMode;

  AttendanceMarkingScreen({this.isEditMode = false});

  @override
  _AttendanceMarkingScreenState createState() => _AttendanceMarkingScreenState();
}

class _AttendanceMarkingScreenState extends State<AttendanceMarkingScreen> {
  String? _projectId;
  List<int> _selectedPeriods = [];
  List<int> _markedPeriods = [];
  DateTime? _selectedDate;
  bool _isLoading = false;
  final _projectIdController = TextEditingController();

  @override
  void dispose() {
    _projectIdController.dispose();
    super.dispose();
  }

  Future<void> _checkMarkedPeriods() async {
    if (_projectId == null || _projectId!.isEmpty || _selectedDate == null) {
      setState(() {
        _markedPeriods = [];
        _selectedPeriods = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Format the date to YYYY-MM-DD
      final dateParts = _selectedDate!.toIso8601String().split('T')[0].split('-');
      final formattedDate = '${dateParts[0]}-${dateParts[1]}-${dateParts[2]}';

      // Check attendance details
      final attendanceDetails = await ApiService().getAttendanceDetails(_projectId!, formattedDate);
      final response = await ApiService().getAttendanceForDate(_projectId!, formattedDate);

      if (response != null && attendanceDetails != null) {
        final markedPeriods = response['markedPeriods'] ?? [];
        final detailsPeriods = attendanceDetails['periods'] ?? {};
        
        // Verify each marked period has actual attendance data
        final verifiedMarkedPeriods = <int>[];
        for (var period in markedPeriods) {
          final periodData = detailsPeriods[period.toString()];
          if (periodData != null && 
              periodData['absent'] != null && 
              periodData['present'] != null &&
              (periodData['absent'].length > 0 || periodData['present'].length > 0)) {
            verifiedMarkedPeriods.add(period);
          }
        }
        
        setState(() {
          _markedPeriods = verifiedMarkedPeriods;
          if (widget.isEditMode) {
            _selectedPeriods = List.from(verifiedMarkedPeriods);
          } else {
            _selectedPeriods.removeWhere((period) => verifiedMarkedPeriods.contains(period));
          }
        });
      } else {
        setState(() {
          _markedPeriods = [];
          if (!widget.isEditMode) {
            _selectedPeriods = [];
          }
        });
      }
    } catch (e) {
      print('Error checking marked periods: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking marked periods: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleProjectIdChange(String value) {
    final trimmedValue = value.trim();
    setState(() {
      _projectId = trimmedValue;
      _selectedPeriods = [];
      _markedPeriods = [];
    });
    if (_selectedDate != null && trimmedValue.isNotEmpty) {
      _checkMarkedPeriods();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedPeriods = [];
        _markedPeriods = [];
      });
      if (_projectId != null && _projectId!.isNotEmpty) {
        _checkMarkedPeriods();
      }
    }
  }

  void _proceedToNextScreen() {
    if (_projectId == null || _projectId!.isEmpty || _selectedDate == null || _selectedPeriods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select date, project ID, and at least one period'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Format the date to YYYY-MM-DD
    final dateParts = _selectedDate!.toIso8601String().split('T')[0].split('-');
    final formattedDate = '${dateParts[0]}-${dateParts[1]}-${dateParts[2]}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentSelectionScreen(
          projectId: _projectId!,
          date: formattedDate,
          periods: _selectedPeriods,
          isEditMode: widget.isEditMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Attendance' : 'Mark Attendance'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Date: ${_selectedDate?.toString().split(' ')[0] ?? 'Select a date'}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _projectIdController,
                    decoration: InputDecoration(
                      labelText: 'Project ID',
                      hintText: 'Enter Project ID',
                      border: OutlineInputBorder(),
                      errorText: _projectId != null && _projectId!.isEmpty ? 'Please enter a Project ID' : null,
                    ),
                    onChanged: _handleProjectIdChange,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  SizedBox(height: 20),
                  if (_projectId != null && _projectId!.isNotEmpty)
                    Text(
                      'Selected Project ID: $_projectId',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  SizedBox(height: 20),
                  Text('Select Periods:'),
                  if (_markedPeriods.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Marked periods: ${_markedPeriods.join(', ')}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(7, (index) {
                      int period = index + 1;
                      final isMarked = _markedPeriods.contains(period);
                      final isSelected = _selectedPeriods.contains(period);
                      final isDisabled = isMarked && !widget.isEditMode;
                      
                      return Container(
                        decoration: BoxDecoration(
                          border: isMarked ? Border.all(color: Colors.orange, width: 2) : null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FilterChip(
                          label: Text(
                            'Period $period${isMarked ? ' (Marked)' : ''}',
                            style: TextStyle(
                              color: isDisabled ? Colors.grey : 
                                    isSelected ? Colors.white : 
                                    isMarked ? Colors.orange : null,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: isDisabled ? null : (selected) {
                            setState(() {
                              if (selected) {
                                _selectedPeriods.add(period);
                              } else {
                                _selectedPeriods.remove(period);
                              }
                            });
                          },
                          backgroundColor: isDisabled ? Colors.grey[200] : 
                                        isMarked ? Colors.orange[50] : null,
                          selectedColor: isMarked ? Colors.orange[200] : Colors.blue[200],
                          checkmarkColor: Colors.white,
                          showCheckmark: true,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _proceedToNextScreen,
                    child: Text(widget.isEditMode ? 'Edit Attendance' : 'Mark Attendance'),
                  ),
                ],
              ),
            ),
    );
  }
}