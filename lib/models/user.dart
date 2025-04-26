class User {
  final String id;
  final String role;
  final String? name;
  final String? year;
  final String? projectId;
  final String? department;
  final String? facultyId;

  User({required this.id, required this.role, this.name, this.year, this.projectId, this.department, this.facultyId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      role: json['role'],
      name: json['name'],
      year: json['year'],
      projectId: json['projectId'],
      department: json['department'],
      facultyId: json['facultyId'],
    );
  }
}

class Attendance {
  final String studentId;
  final int sessionsHeld;
  final int sessionsPresent;

  Attendance({required this.studentId, required this.sessionsHeld, required this.sessionsPresent});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      studentId: json['studentId'],
      sessionsHeld: json['sessionsHeld'],
      sessionsPresent: json['sessionsPresent'],
    );
  }
}