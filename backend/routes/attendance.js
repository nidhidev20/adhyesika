const express = require('express');
const router = express.Router();
const attendanceController = require('../controllers/attendanceController');
const auth = require('../middleware/auth');

// Mark attendance for a project
router.post('/mark', auth, attendanceController.markAttendance);

// Get attendance details for a specific date and project
router.get('/details', auth, attendanceController.getAttendanceDetails);

// Get student's cumulative attendance
router.get('/student/:studentId', auth, attendanceController.getStudentAttendance);

// Check if attendance is marked for a date
router.get('/check', auth, attendanceController.checkAttendance);

// Get all students for a project
router.get('/students/:projectId', auth, attendanceController.getStudentsByProjectId);

module.exports = router;