const mongoose = require('mongoose');

const adminSchema = new mongoose.Schema({
  adminId: { type: String, unique: true },
  name: String,
  password: String,
  role: { type: String, default: 'admin' },
});

module.exports = mongoose.model('Admin', adminSchema);