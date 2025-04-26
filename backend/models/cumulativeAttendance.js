const mongoose = require('mongoose');

const cumulativeAttendanceSchema = new mongoose.Schema({
  studentId: { type: String, unique: true },
  sessionsHeld: Number,
  sessionsPresent: Number,
});

module.exports = mongoose.model('CumulativeAttendance', cumulativeAttendanceSchema);