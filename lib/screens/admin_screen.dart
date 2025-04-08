import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildAdminCard(
              'Manage Users',
              Icons.people,
              Colors.blue,
              () {},
            ),
            _buildAdminCard(
              'Attendance Reports',
              Icons.bar_chart,
              Colors.green,
              () {},
            ),
            _buildAdminCard(
              'Class Management',
              Icons.class_,
              Colors.orange,
      
               () {},
            ),
            _buildAdminCard(
              'System Settings',
              Icons.settings,
              Colors.purple,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}