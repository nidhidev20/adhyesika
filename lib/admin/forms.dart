import 'package:flutter/material.dart';

class CreateForm extends StatelessWidget {
  final ValueNotifier<bool> _dark = ValueNotifier<bool>(true);
  final ValueNotifier<double> _widthFactor = ValueNotifier<double>(1.0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ValueListenableBuilder<bool>(
        valueListenable: _dark,
        builder: (context, isDark, child) {
          return ValueListenableBuilder<double>(
            valueListenable: _widthFactor,
            builder: (context, factor, child) {
              return Scaffold(
                backgroundColor: _dark.value ? Colors.black : Colors.white,
                appBar: AppBar(
                  backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
                  title: Text(
                    'Project Form',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
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
                      alignment: Alignment.topCenter,
                      child: InteractiveProjectForm(isDarkMode: _dark.value),
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

class InteractiveProjectForm extends StatefulWidget {
  final bool isDarkMode;

  const InteractiveProjectForm({super.key, required this.isDarkMode});

  @override
  State<InteractiveProjectForm> createState() => _InteractiveProjectFormState();
}

class _InteractiveProjectFormState extends State<InteractiveProjectForm> {
  // Form controllers
  final _projectNameController = TextEditingController();
  final _projectNoController = TextEditingController();
  final _mentorNameController = TextEditingController();
  final _problemStatementController = TextEditingController();

  // Student 1 controllers
  final _student1NameController = TextEditingController();
  final _student1RollNoController = TextEditingController();

  // Student 2 controllers
  final _student2NameController = TextEditingController();
  final _student2RollNoController = TextEditingController();

  // List of students beyond the default two
  final List<Map<String, TextEditingController>> _additionalStudents = [];

  @override
  void dispose() {
    // Dispose all controllers
    _projectNameController.dispose();
    _projectNoController.dispose();
    _mentorNameController.dispose();
    _problemStatementController.dispose();
    _student1NameController.dispose();
    _student1RollNoController.dispose();
    _student2NameController.dispose();
    _student2RollNoController.dispose();

    // Dispose additional student controllers
    for (var student in _additionalStudents) {
      student['name']?.dispose();
      student['rollNo']?.dispose();
    }

    super.dispose();
  }

  void _addStudent() {
    setState(() {
      _additionalStudents.add({
        'name': TextEditingController(),
        'rollNo': TextEditingController(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth =
        screenWidth * 0.9; // Use 90% of screen width for the form container
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    // Use a fixed max width for better control on larger screens
    final formMaxWidth = 600.0;
    final actualFormWidth =
        containerWidth < formMaxWidth ? containerWidth : formMaxWidth;

    return Container(
      constraints: BoxConstraints(
        maxWidth: formMaxWidth,
      ), // Apply max width constraint
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.black : Colors.white,
      ),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          // Background shapes remain unchanged
          Positioned(
            left: 240.99,
            top: -186,
            child: Transform(
              transform:
                  Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(0.92),
              child: Container(
                width: 214,
                height: 202,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xBC3E5879),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          // Other background shapes (unchanged)
          Positioned(
            left: 451.76,
            top: 19.56,
            child: Transform(
              transform:
                  Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(0.71),
              child: Container(
                width: 217.45,
                height: 204.23,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xBC3E5879),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 279.97,
            top: -72,
            child: Transform(
              transform:
                  Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(0.17),
              child: Container(
                width: 222.59,
                height: 199.23,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xBC3E5879),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -21.01,
            top: 626,
            child: Transform(
              transform:
                  Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(0.92),
              child: Container(
                width: 214,
                height: 202,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xBC3E5879),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 193.08,
            top: 833,
            child: Transform(
              transform:
                  Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(0.71),
              child: Container(
                width: 217.45,
                height: 204.23,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xBC3E5879),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -74.03,
            top: 803,
            child: Transform(
              transform:
                  Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(0.17),
              child: Container(
                width: 222.59,
                height: 199.23,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xBC3E5879),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),

          // Main Content Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '← Form Details',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Form fields with controllers
                _buildInteractiveFormField(
                  label: 'Project name',
                  controller: _projectNameController,
                  width: actualFormWidth,
                ),
                const SizedBox(height: 20),

                _buildInteractiveFormField(
                  label: 'Project no',
                  controller: _projectNoController,
                  width: actualFormWidth,
                ),
                const SizedBox(height: 20),

                _buildInteractiveFormField(
                  label: 'Mentor Name',
                  controller: _mentorNameController,
                  width: actualFormWidth,
                ),
                const SizedBox(height: 20),

                _buildInteractiveFormField(
                  label: 'Problem Statement',
                  controller: _problemStatementController,
                  width: actualFormWidth,
                  height: 150,
                  maxLines: 5,
                ),
                const SizedBox(height: 30),

                // Student 1 Section (BLACK text)
                Text(
                  'Student 1',
                  style: TextStyle(
                    color: Colors.black, // Changed to black as requested
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                _buildInteractiveFormField(
                  label: 'Student name',
                  controller: _student1NameController,
                  width: actualFormWidth,
                ),
                const SizedBox(height: 20),

                _buildInteractiveFormField(
                  label: 'Roll No',
                  controller: _student1RollNoController,
                  width: actualFormWidth,
                ),
                const SizedBox(height: 30),

                // Student 2 Section (BLACK text)
                Text(
                  'Student 2',
                  style: TextStyle(
                    color: Colors.black, // Changed to black as requested
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                _buildInteractiveFormField(
                  label: 'Student name',
                  controller: _student2NameController,
                  width: actualFormWidth,
                ),
                const SizedBox(height: 20),

                _buildInteractiveFormField(
                  label: 'Roll No',
                  controller: _student2RollNoController,
                  width: actualFormWidth,
                ),
                const SizedBox(height: 30),

                // Additional students (dynamically added)
                ..._buildAdditionalStudents(actualFormWidth),

                // Add Student Button (BLACK text)
                TextButton(
                  onPressed: _addStudent,
                  child: const Text(
                    'Add Student +',
                    style: TextStyle(
                      color: Colors.black, // Changed to black as requested
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Submit button
                const SizedBox(height: 40),
                SizedBox(
                  width: actualFormWidth, // Use the calculated width
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle form submission
                      _submitForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E5879),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Submit Form',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 50), // Add some bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAdditionalStudents(double containerWidth) {
    List<Widget> studentWidgets = [];

    for (int i = 0; i < _additionalStudents.length; i++) {
      final studentIndex = i + 3; // Starting from Student 3
      studentWidgets.addAll([
        Text(
          'Student $studentIndex',
          style: const TextStyle(
            color: Colors.black, // Black text color
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        _buildInteractiveFormField(
          label: 'Student name',
          controller: _additionalStudents[i]['name']!,
          width: containerWidth,
        ),
        const SizedBox(height: 20),

        _buildInteractiveFormField(
          label: 'Roll No',
          controller: _additionalStudents[i]['rollNo']!,
          width: containerWidth,
        ),
        const SizedBox(height: 30),
      ]);
    }

    return studentWidgets;
  }

  Widget _buildInteractiveFormField({
    required String label,
    required TextEditingController controller,
    required double width,
    double height = 60,
    int maxLines = 1,
  }) {
    return Container(
      width: width, // Use the passed width
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFF3E5879),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 26,
            vertical: 15,
          ),
          border: InputBorder.none,
          hintText: label,
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // Get all form data with explicit types
    final Map<String, dynamic> projectData = {
      'projectName': _projectNameController.text,
      'projectNo': _projectNoController.text,
      'mentorName': _mentorNameController.text,
      'problemStatement': _problemStatementController.text,
      'students': <Map<String, String>>[
        // Explicitly typed list
        {
          'name': _student1NameController.text,
          'rollNo': _student1RollNoController.text,
        },
        {
          'name': _student2NameController.text,
          'rollNo': _student2RollNoController.text,
        },
      ],
    };

    // Get the typed list to add more students
    final List<Map<String, String>> studentsList =
        projectData['students'] as List<Map<String, String>>;

    // Add additional students
    for (var student in _additionalStudents) {
      studentsList.add({
        // Add to the typed list
        'name': student['name']!.text,
        'rollNo': student['rollNo']!.text,
      });
    }

    // Show submission feedback (you can replace with API call)
    if (mounted) {
      // Check if the widget is still in the tree
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    }

    // For debugging - print data to console
    // ignore: avoid_print
    print('Form Data: $projectData');
  }
}
