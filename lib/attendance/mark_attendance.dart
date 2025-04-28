import 'package:flutter/material.dart';

class MarkAttendance extends StatelessWidget {
  final ValueNotifier<bool> _dark = ValueNotifier<bool>(true);
  final ValueNotifier<double> _widthFactor = ValueNotifier<double>(1.0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF3E5879),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF3E5879),
          primary: Color(0xFF3E5879),
        ),
      ),
      home: ValueListenableBuilder<bool>(
        valueListenable: _dark,
        builder: (context, color, child) {
          return ValueListenableBuilder<double>(
            valueListenable: _widthFactor,
            builder: (context, factor, child) {
              return Scaffold(
                backgroundColor: _dark.value ? Colors.black : Colors.white,
                appBar: AppBar(
                  actions: [
                    Switch(
                      value: _dark.value,
                      onChanged: (value) {
                        _dark.value = value;
                      },
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      width:
                          MediaQuery.of(context).size.width *
                          _widthFactor.value,
                      child: AttendanceScreen(role: 'Teacher'),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  final String role;
  const AttendanceScreen({Key? key, required this.role}) : super(key: key);

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

  String selectedDate = DateTime.now().toString().substring(0, 10);
  String selectedHour = '1';
  String selectedYear = 'Year 1';
  String selectedClass = 'Class A';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive sizes
    final containerWidth = screenWidth > 430 ? 430.0 : screenWidth;
    final containerHeight = screenHeight > 932 ? 932.0 : screenHeight;

    return Container(
      width: containerWidth,
      height: containerHeight,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.loose,
        children: [
          // Decorative background elements - made safe with constraints
          _buildDecorativeElement(260, -62.77, -0.17, screenWidth),
          _buildDecorativeElement(149, -77.45, -0.54, screenWidth),
          _buildDecorativeElement(
            screenWidth > 442.68 ? 442.68 : screenWidth * 0.9,
            -12,
            0.49,
            screenWidth,
          ),
          _buildDecorativeElement(
            -52,
            containerHeight * 0.9,
            -0.13,
            screenWidth,
          ),
          _buildDecorativeElement(
            containerWidth * 0.5,
            containerHeight * 0.9,
            0.76,
            screenWidth,
          ),
          _buildDecorativeElement(
            -113.26,
            containerHeight * 0.75,
            0.43,
            screenWidth,
          ),

          // Header
          Positioned(
            left: 11,
            top: 20,
            child: Text(
              '← Mark Attendance',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Inter',
                height: 0,
              ),
            ),
          ),

          // Selection fields - adjusted for responsive layout
          _buildSelectionField(
            left: screenWidth * 0.1,
            top: 100,
            label: 'Date',
            content: _buildDateSelector(),
          ),

          _buildSelectionField(
            left: screenWidth * 0.1,
            top: 200,
            label: 'Select Hour',
            content: _buildDropdown(
              selectedHour,
              ['1', '2', '3', '4', '5', '6', '7', '8'],
              (newValue) {
                setState(() {
                  selectedHour = newValue!;
                });
              },
            ),
          ),

          _buildSelectionField(
            left: screenWidth * 0.1,
            top: 300,
            label: 'Select Year',
            content: _buildDropdown(
              selectedYear,
              ['Year 1', 'Year 2', 'Year 3', 'Year 4'],
              (newValue) {
                setState(() {
                  selectedYear = newValue!;
                });
              },
            ),
          ),

          _buildSelectionField(
            left: screenWidth * 0.1,
            top: 400,
            label: 'Select Class',
            content: _buildDropdown(
              selectedClass,
              ['Class A', 'Class B', 'Class C', 'Class D'],
              (newValue) {
                setState(() {
                  selectedClass = newValue!;
                });
              },
            ),
          ),

          // Enter button - positioned relatively
          Positioned(
            left: containerWidth * 0.6,
            top: containerHeight * 0.8,
            child: GestureDetector(
              onTap: () {
                _showAttendanceSheet();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 13,
                ),
                decoration: ShapeDecoration(
                  color: Color(0xFF3E5879),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Enter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build decorative background elements safely
  Widget _buildDecorativeElement(
    double left,
    double top,
    double rotateZ,
    double screenWidth,
  ) {
    return Positioned(
      left: left.clamp(-screenWidth * 0.3, screenWidth),
      top: top,
      child: Transform(
        transform:
            Matrix4.identity()
              ..translate(0.0, 0.0)
              ..rotateZ(rotateZ),
        child: Container(
          width: 222,
          height: 190,
          decoration: ShapeDecoration(
            color: Color(0xBC3E5879),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build selection fields with consistent styling
  Widget _buildSelectionField({
    required double left,
    required double top,
    required String label,
    required Widget content,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: ShapeDecoration(
          color: Color(0xFF3E5879),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Inter',
              ),
            ),
            content,
          ],
        ),
      ),
    );
  }

  // Helper method to build date selector
  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked.toString().substring(0, 10);
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          selectedDate,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  // Helper method to build dropdown selectors
  Widget _buildDropdown(
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: SizedBox(),
        style: TextStyle(color: Color(0xFF3E5879), fontSize: 18),
        onChanged: onChanged,
        items:
            items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
      ),
    );
  }

  // Method to show attendance sheet
  void _showAttendanceSheet() {
    // Create a local copy of the students map for the dialog
    Map<String, bool> localStudents = Map<String, bool>.from(students);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (BuildContext sheetContext) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setSheetState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Mark Attendance',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E5879),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Date: $selectedDate | Hour: $selectedHour | $selectedYear | $selectedClass',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 600
                                        ? 4
                                        : 3,
                                childAspectRatio: 1.0,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: localStudents.length,
                          itemBuilder: (context, index) {
                            String key = localStudents.keys.elementAt(index);
                            bool isPresent = localStudents[key]!;

                            return GestureDetector(
                              onTap: () {
                                // Update the local state when a student is tapped
                                setSheetState(() {
                                  localStudents[key] = !isPresent;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      isPresent
                                          ? Color(0xFF3E5879)
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.person,
                                        color:
                                            isPresent
                                                ? Color(0xFF3E5879)
                                                : Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      key,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      isPresent ? 'Present' : 'Absent',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3E5879),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              // Mark all students as present in the local state
                              setSheetState(() {
                                localStudents.updateAll((key, value) => true);
                              });
                            },
                            child: const Text('Mark all PRESENT'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              // Mark all students as absent in the local state
                              setSheetState(() {
                                localStudents.updateAll((key, value) => false);
                              });
                            },
                            child: const Text('Mark all ABSENT'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3E5879),
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // Update the main state with the local state when saving
                          setState(() {
                            students = Map<String, bool>.from(localStudents);
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Attendance saved successfully!'),
                              backgroundColor: Color(0xFF3E5879),
                            ),
                          );
                        },
                        child: Text(
                          'Save Attendance',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
