import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
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
                      backgroundColor:
                      _dark.value ? Colors.black : Colors.white,
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
                      body: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                _widthFactor.value,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ResponsiveAdminDashboard(),
                                ],
                              ),
                            ),
                          )));
                },
              );
            }));
  }
}

class ResponsiveAdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive calculations
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Calculate aspect ratio based on original design (430x932)
    final designAspectRatio = 430 / 932;
    final currentAspectRatio = screenWidth / screenHeight;

    // Use layout builder to get constraints
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        // Scale factors
        final scaleFactor = maxWidth / 430; // Based on original design width

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Main container with proper aspect ratio
            Container(
              width: maxWidth,
              constraints: BoxConstraints(
                minHeight: 500, // Minimum height to prevent content crushing
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back navigation text
                  Padding(
                    padding: EdgeInsets.only(
                      left: 22 * scaleFactor,
                      top: 20,
                      bottom: 40,
                    ),
                    child: Text(
                      '← Admin Dashboard',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20 * (scaleFactor > 0.7 ? 1 : 0.9), // Slightly smaller font on very small screens
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),

                  // Menu items container
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16 * scaleFactor),
                    child: Column(
                      children: [
                        _buildMenuButton('Manage Students', scaleFactor),
                        SizedBox(height: 20 * scaleFactor),

                        _buildMenuButton('Manage Teachers', scaleFactor),
                        SizedBox(height: 20 * scaleFactor),

                        _buildMenuButton('Forms', scaleFactor),
                        SizedBox(height: 20 * scaleFactor),

                        _buildMenuButton('Attendance', scaleFactor),
                        SizedBox(height: 60 * scaleFactor), // Extra space at bottom
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Background decorative elements
            ..._buildBackgroundElements(scaleFactor, maxWidth),
          ],
        );
      },
    );
  }

  // Helper method to build menu buttons
  Widget _buildMenuButton(String text, double scaleFactor) {
    return Container(
      width: double.infinity,
      height: 94 * (scaleFactor > 0.5 ? scaleFactor : 0.5), // Ensure minimum height
      padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
      decoration: ShapeDecoration(
        color: Color(0xFF3E5879),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20 * scaleFactor),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20 * (scaleFactor > 0.7 ? 1 : 0.9), // Slightly smaller font on very small screens
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  // Helper method to build background decorative elements
  List<Widget> _buildBackgroundElements(double scaleFactor, double containerWidth) {
    // Create a list of positioned decorative shapes that won't cause overflow
    return [
      // Bottom right decorative element 1
      Positioned(
        right: -containerWidth * 0.1,
        bottom: -containerWidth * 0.2,
        child: Transform.rotate(
          angle: 1.35,
          child: Container(
            width: containerWidth * 0.5,
            height: containerWidth * 0.45,
            decoration: ShapeDecoration(
              color: Color(0xBC3E5879),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20 * scaleFactor),
              ),
            ),
          ),
        ),
      ),
      // Bottom right decorative element 2
      Positioned(
        right: -containerWidth * 0.3,
        bottom: -containerWidth * 0.4,
        child: Transform.rotate(
          angle: 2.40,
          child: Container(
            width: containerWidth * 0.5,
            height: containerWidth * 0.45,
            decoration: ShapeDecoration(
              color: Color(0xBC3E5879),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20 * scaleFactor),
              ),
            ),
          ),
        ),
      ),
      // Bottom left decorative element
      Positioned(
        left: -containerWidth * 0.2,
        bottom: -containerWidth * 0.3,
        child: Transform.rotate(
          angle: 2.17,
          child: Container(
            width: containerWidth * 0.5,
            height: containerWidth * 0.45,
            decoration: ShapeDecoration(
              color: Color(0xBC3E5879),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20 * scaleFactor),
              ),
            ),
          ),
        ),
      ),
      // Top right decorative element 1
      Positioned(
        right: -containerWidth * 0.1,
        top: -containerWidth * 0.2,
        child: Transform.rotate(
          angle: 0.17,
          child: Container(
            width: containerWidth * 0.5,
            height: containerWidth * 0.45,
            decoration: ShapeDecoration(
              color: Color(0xBC3E5879),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20 * scaleFactor),
              ),
            ),
          ),
        ),
      ),
      // Top right decorative element 2
      Positioned(
        right: -containerWidth * 0.3,
        top: -containerWidth * 0.1,
        child: Transform.rotate(
          angle: 0.71,
          child: Container(
            width: containerWidth * 0.5,
            height: containerWidth * 0.45,
            decoration: ShapeDecoration(
              color: Color(0xBC3E5879),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20 * scaleFactor),
              ),
            ),
          ),
        ),
      ),
      // Top right decorative element 3
      Positioned(
        right: -containerWidth * 0.2,
        top: -containerWidth * 0.4,
        child: Transform.rotate(
          angle: 0.92,
          child: Container(
            width: containerWidth * 0.5,
            height: containerWidth * 0.45,
            decoration: ShapeDecoration(
              color: Color(0xBC3E5879),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20 * scaleFactor),
              ),
            ),
          ),
        ),
      ),
    ];
  }
}