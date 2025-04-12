import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
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
                body: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * _widthFactor.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: StudentProfileScreen(),
                          ),
                        ),
                      ],
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

class StudentProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 430,
      constraints: BoxConstraints(minHeight: 932),
      clipBehavior: Clip.none,
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background decoration elements with safe positioning
          Positioned(
            right: -100,
            top: -50,
            child: _buildDecorativeContainer(225, 199, 0.30),
          ),
          Positioned(
            right: -50,
            top: 0,
            child: _buildDecorativeContainer(225, 199, 0.54),
          ),
          Positioned(
            right: 0,
            top: -100,
            child: _buildDecorativeContainer(225, 199, 0.67),
          ),
          Positioned(
            left: 0,
            bottom: -50,
            child: _buildDecorativeContainer(225, 199, 1.35),
          ),
          Positioned(
            right: 0,
            bottom: -80,
            child: _buildDecorativeContainer(228.56, 199, 2.40),
          ),
          Positioned(
            left: -50,
            bottom: -80,
            child: _buildDecorativeContainer(228.56, 199, 2.17),
          ),

          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 64),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Text(
                  'Student Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  '23BD1A054J',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Student details
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Department',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      'CSE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Section',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      'C',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Year',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '2',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              // Attendance overview
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Text(
                  'Attendance Overview',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              SizedBox(height: 15),

              Center(
                child: Text(
                  '75%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Attendance calendar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sat',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        _buildAttendanceIcon(),
                        SizedBox(width: 4),
                        _buildAttendanceIcon(),
                        SizedBox(width: 4),
                        _buildAttendanceIcon(),
                        SizedBox(width: 4),
                        _buildAttendanceIcon(),
                        SizedBox(width: 4),
                        _buildAttendanceIcon(),
                      ],
                    ),
                    SizedBox(height: 15),

                    Text(
                      'MON',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 10),

                    Row(
                      children: [
                        _buildAttendanceIcon(),
                        SizedBox(width: 4),
                        _buildAttendanceIcon(),
                        SizedBox(width: 4),
                        _buildAttendanceIcon(),
                        SizedBox(width: 4),
                        _buildAttendanceIcon(),
                        SizedBox(width: 4),
                        _buildAttendanceIcon(),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35),

              // Attendance summary
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '50',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          'Present',
                          style: TextStyle(
                            color: Color(0xFF0EA718),
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    Column(
                    children: [
                        Text(
                        '25',
                          style: TextStyle(
                          color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                        'Absent',
                          style: TextStyle(
                          color: Color(0xFFFE2525),
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    Column(
                    children: [
                        Text(
                        '0',
                          style: TextStyle(
                          color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                        'No session',
                          style: TextStyle(
                          color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeContainer(double width, double height, double rotation) {
    return Transform(
    transform: Matrix4.identity()
        ..translate(0.0, 0.0)
        ..rotateZ(rotation),
      child: Container(
      width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
        color: Color(0xBC3E5879),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
  Widget _buildAttendanceIcon() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        shape: BoxShape.circle,
      ),
      // Replacing network images with placeholder color to avoid overflow issues
      // If you need to keep the images, ensure they have proper error handling
    );
  }
}