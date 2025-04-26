const mongoose = require('mongoose');

const attendanceSchema = new mongoose.Schema({
  date: {
    type: String,
    required: true
  },
  projectId: {
    type: String,
    required: true
  },
  periods: {
    1: { present: [String], absent: [String] },
    2: { present: [String], absent: [String] },
    3: { present: [String], absent: [String] },
    4: { present: [String], absent: [String] },
    5: { present: [String], absent: [String] },
    6: { present: [String], absent: [String] },
    7: { present: [String], absent: [String] }
  }
});

// Create compound index for date and projectId
attendanceSchema.index({ date: 1, projectId: 1 }, { unique: true });

module.exports = mongoose.model('Attendance', attendanceSchema);