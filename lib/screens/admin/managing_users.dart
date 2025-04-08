import 'package:flutter/material.dart';


class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.add),
                            title: Text('Add Students'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddStudentScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit Students'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditStudentScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete Students'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DeleteStudentScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text('Manage Students'),
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.add),
                            title: Text('Add Teachers'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddStudentScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit Teachers'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditStudentScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete Teachers'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DeleteStudentScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text('Manage Teachers'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Forms'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Permissions'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddStudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Student')),
      body: Center(child: Text('Add New Student')),
    );
  }
}

class EditStudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Student')),
      body: Center(child: Text('Edit Students')),
    );
  }
}

class DeleteStudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delete Student')),
      body: Center(child: Text('Delete Students')),
    );
  }
}