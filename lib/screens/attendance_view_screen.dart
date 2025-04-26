import 'package:flutter/material.dart';
import '../models/user.dart';

class AttendanceViewScreen extends StatefulWidget {
  final Attendance attendance;
  final String studentName;

  const AttendanceViewScreen({required this.attendance, required this.studentName});

  @override
  _AttendanceViewScreenState createState() => _AttendanceViewScreenState();
}

class _AttendanceViewScreenState extends State<AttendanceViewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Animation takes 2 seconds
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getAttendanceColor(double percentage) {
    if (widget.attendance.sessionsHeld == 0) return Colors.grey;
    if (percentage < 65) return Colors.red;
    if (percentage < 75) return Colors.yellow;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.attendance.sessionsHeld == 0
        ? 0.0
        : (widget.attendance.sessionsPresent / widget.attendance.sessionsHeld * 100);
    final percentageText = percentage.toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: ${widget.studentName}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Attendance: ${widget.attendance.sessionsPresent}/${widget.attendance.sessionsHeld} ($percentageText%)',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SemiRingWidget(
                  percentage: percentage * _animation.value,
                  color: _getAttendanceColor(percentage),
                  percentageText: percentageText,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SemiRingWidget extends StatelessWidget {
  final double percentage;
  final Color color;
  final String percentageText;

  const SemiRingWidget({
    required this.percentage,
    required this.color,
    required this.percentageText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(100, 100), // Square for circular ring
          painter: SemiRingPainter(
            percentage: percentage,
            color: color,
          ),
        ),
        Text(
          '$percentageText%',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class SemiRingPainter extends CustomPainter {
  final double percentage;
  final Color color;

  SemiRingPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Background ring (optional, faint grey)
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.width),
      180 * (3.14159 / 180), // Start at bottom-left
      180 * (3.14159 / 180), // Full semi-circle
      false,
      bgPaint,
    );

    // Foreground animated ring
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (percentage / 100) * 180; // Map percentage to 180 degrees
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.width),
      180 * (3.14159 / 180), // Start at bottom-left (U-shape)
      (sweepAngle * (3.14159 / 180)), // Sweep based on percentage
      false, // Stroke, not fill
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}