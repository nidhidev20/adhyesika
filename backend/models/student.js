const mongoose = require('mongoose');

const studentSchema = new mongoose.Schema({
  name: String,
  studentId: { type: String, unique: true },
  year: String,
  projectId: String,
  department: String,
  role: { type: String, default: 'student' },
  password: String,
});

module.exports = mongoose.model('Student', studentSchema);