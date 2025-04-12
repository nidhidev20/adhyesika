import 'package:flutter/material.dart';
import 'mark_attendance.dart';
class TeacherDashboard extends StatelessWidget {
  final ValueNotifier<bool> _dark = ValueNotifier<bool>(true);
  final ValueNotifier<double> _widthFactor = ValueNotifier<double>(1.0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                    DropdownButton<double>(
                      value: _widthFactor.value,
                      onChanged: (value) {
                        _widthFactor.value = value!;
                      },
                      items: [
                        DropdownMenuItem<double>(
                          value: 0.5,
                          child: Text('Size: 50%'),
                        ),
                        DropdownMenuItem<double>(
                          value: 0.75,
                          child: Text('Size: 75%'),
                        ),
                        DropdownMenuItem<double>(
                          value: 1.0,
                          child: Text('Size: 100%'),
                        ),
                      ],
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * _widthFactor.value,
                      child: NoOverflowLayout(),
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

class NoOverflowLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return Container(
          width: maxWidth,
          // Set minimum height but allow scrolling
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          color: Colors.white,
          child: Stack(
            children: [
              // Background decorative elements that stay in bounds
              _buildBackgroundElements(maxWidth),

              // Main content that adapts to width
              _buildMainContent(context, maxWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackgroundElements(double maxWidth) {
    return SizedBox(
      width: maxWidth,
      height: 900, // Approximate height from original design
      child: ClipRect(
        child: Stack(
          fit: StackFit.loose,
          children: [
            // Top right decorative element
            Positioned(
              right: -maxWidth * 0.1,
              top: 22,
              child: _buildDecorativeBox(maxWidth * 0.5, maxWidth * 0.4, 0.47),
            ),
            // Bottom left element 1
            Positioned(
              left: -maxWidth * 0.3,
              bottom: 100,
              child: _buildDecorativeBox(maxWidth * 0.5, maxWidth * 0.4, 0.47),
            ),
            // Bottom left element 2
            Positioned(
              left: -maxWidth * 0.25,
              bottom: 30,
              child: _buildDecorativeBox(maxWidth * 0.5, maxWidth * 0.4, 0.11),
            ),
            // Bottom right element
            Positioned(
              right: maxWidth * 0.1,
              bottom: -maxWidth * 0.1,
              child: _buildDecorativeBox(maxWidth * 0.5, maxWidth * 0.4, 0.94),
            ),
            // Top right element
            Positioned(
              right: maxWidth * 0.1,
              top: -maxWidth * 0.1,
              child: _buildDecorativeBox(maxWidth * 0.5, maxWidth * 0.4, -0.32),
            ),
            // Top left element
            Positioned(
              left: maxWidth * 0.1,
              top: -maxWidth * 0.2,
              child: _buildDecorativeBox(maxWidth * 0.5, maxWidth * 0.4, -0.35),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeBox(double width, double height, double rotation) {
    return Transform(
      transform: Matrix4.identity()..rotateZ(rotation),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Color(0xBC3E5879),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, double maxWidth) {
    // Scale factor for responsive sizing
    final designWidth = 430.0; // Original iPhone design width
    final scaleFactor = (maxWidth / designWidth).clamp(0.5, 1.2);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16 * scaleFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button text
          Padding(
            padding: EdgeInsets.only(
              top: 66 * scaleFactor,
              bottom: 40 * scaleFactor,
            ),
            child: Text(
              '← Teacher ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24 * scaleFactor,
                fontFamily: 'Inter',
              ),
            ),
          ),
          // Mark Attendance Card
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MarkAttendance()),
              );
            },
            child: _buildAttendanceCard(
              context: context,
              title: 'Mark Attendance',
              maxWidth: maxWidth,
              scaleFactor: scaleFactor,
            ),
          ),

          SizedBox(height: 40 * scaleFactor),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MarkAttendance()), // Assuming same screen
              );
            },
            child: _buildAttendanceCard(
              context: context,
              title: 'Edit Attendance',
              maxWidth: maxWidth,
              scaleFactor: scaleFactor,
            ),
          ),
          // Add space at bottom
          SizedBox(height: 60 * scaleFactor),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard({
    required BuildContext context,
    required String title,
    required double maxWidth,
    required double scaleFactor,
  }) {
    final cardWidth = maxWidth - (32 * scaleFactor); // Account for padding
    final imageSize = 100 * scaleFactor;

    return Container(
      width: cardWidth,
      padding: EdgeInsets.symmetric(
        vertical: 45 * scaleFactor,
        horizontal: 25 * scaleFactor,
      ),
      decoration: ShapeDecoration(
        color: Color(0xFF3E5879),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20 * scaleFactor),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image with original URL
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://picsum.photos/100/100"),
                fit: BoxFit.fill,
              ),
            ),
          ),

          SizedBox(width: 30 * scaleFactor),

          // Text with overflow protection
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24 * scaleFactor,
                fontFamily: 'Inter',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}