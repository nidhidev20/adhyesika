const mongoose = require('mongoose');

const facultySchema = new mongoose.Schema({
  facultyId: { type: String, unique: true },
  password: String,
  role: String,
});

module.exports = mongoose.model('Faculty', facultySchema);