const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const Student = require('./models/student');
const Faculty = require('./models/faculty');
const Admin = require('./models/admin');
const Attendance = require('./models/attendance');
const CumulativeAttendance = require('./models/cumulativeAttendance');

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/newtest').then(() => {
  console.log('Connected to MongoDB for seeding');
}).catch((error) => {
  console.error('MongoDB connection error:', error);
  process.exit(1);
});

const seedDatabase = async () => {
  try {
    // Clear existing data
    await Student.deleteMany({});
    await Faculty.deleteMany({});
    await Admin.deleteMany({});
    await Attendance.deleteMany({});
    await CumulativeAttendance.deleteMany({});

    // Hash passwords
    const hashedPassword = await bcrypt.hash('password123', 10);

    // Seed Students
    const students = [
      {
        name: 'John Doe',
        studentId: 'STU001',
        year: '3',
        projectId: 'P001',
        department: 'CSE',
        role: 'student',
        password: hashedPassword,
      },
      {
        name: 'Jane Smith',
        studentId: 'STU002',
        year: '3',
        projectId: 'P001',
        department: 'CSE',
        role: 'student',
        password: hashedPassword,
      },
      {
        name: 'Bob Wilson',
        studentId: 'STU004',
        year: '3',
        projectId: 'P001', 
        department: 'CSE',
        role: 'student',
        password: hashedPassword,
      },
      {
        name: 'Alice Johnson',
        studentId: 'STU003',
        year: '4',
        projectId: 'P002',
        department: 'ECE',
        role: 'student',
        password: hashedPassword,
      },
    ];

    // Seed Faculty
    const faculty = [
      {
        facultyId: 'FAC001',
        password: hashedPassword,
        role: 'faculty',
      },
      {
        facultyId: 'FAC002',
        password: hashedPassword,
        role: 'faculty',
      },
    ];

    // Seed Admins
    const admins = [
      {
        adminId: 'ADM001',
        name: 'Admin User',
        password: hashedPassword,
        role: 'admin',
      },
    ];

    // Insert data
    await Student.insertMany(students);
    await Faculty.insertMany(faculty);
    await Admin.insertMany(admins);

    // Seed Attendance (Optional)
    const attendanceRecords = [
      {
        aid: new mongoose.Types.ObjectId().toString(),
        date: '2025-04-10',
        year: '3',
        projectId: 'P001',
        periods: {
          1: {
            present: ['STU001', 'STU002'],
            absent: ['STU004']
          },
          2: {
            present: ['STU001', 'STU002', 'STU004'],
            absent: []
          },
          3: {
            present: ['STU001', 'STU004'],
            absent: ['STU002']
          },
          4: {
            present: ['STU001', 'STU002', 'STU004'],
            absent: []
          },
          5: {
            present: ['STU001', 'STU002'],
            absent: ['STU004']
          },
          6: {
            present: ['STU001', 'STU004'],
            absent: ['STU002']
          },
          7: {
            present: ['STU001', 'STU002', 'STU004'],
            absent: []
          }
        }
      },
      {
        aid: new mongoose.Types.ObjectId().toString(),
        date: '2025-04-11',
        year: '4',
        projectId: 'P002',
        periods: {
          1: {
            present: ['STU003'],
            absent: []
          },
          2: {
            present: ['STU003'],
            absent: []
          },
          3: {
            present: ['STU003'],
            absent: []
          },
          4: {
            present: ['STU003'],
            absent: []
          },
          5: {
            present: ['STU003'],
            absent: []
          },
          6: {
            present: ['STU003'],
            absent: []
          },
          7: {
            present: ['STU003'],
            absent: []
          }
        }
      }
    ];

    // Seed Cumulative Attendance (Optional)
    const cumulativeAttendance = [
      {
        studentId: 'STU001',
        sessionsHeld: 7,
        sessionsPresent: 6,
      },
      {
        studentId: 'STU002',
        sessionsHeld: 7,
        sessionsPresent: 5,
      },
      {
        studentId: 'STU003',
        sessionsHeld: 7,
        sessionsPresent: 7,
      },
      {
        studentId: 'STU004',
        sessionsHeld: 7,
        sessionsPresent: 5,
      }
    ];

    await Attendance.insertMany(attendanceRecords);
    await CumulativeAttendance.insertMany(cumulativeAttendance);

    console.log('Database seeded successfully!');
  } catch (error) {
    console.error('Error seeding database:', error);
  } finally {
    mongoose.connection.close();
  }
};

// Run the seed function
seedDatabase();