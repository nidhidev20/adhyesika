const Attendance = require('../models/attendance');
const CumulativeAttendance = require('../models/cumulativeAttendance');
const Student = require('../models/student');

// Helper function to check if a date is today
const isToday = (dateString) => {
  const today = new Date();
  const inputDate = new Date(dateString);
  return today.toDateString() === inputDate.toDateString();
};

exports.getStudentsByProjectId = async (req, res) => {
  const { projectId } = req.params;

  try {
    const students = await Student.find({ projectId }).select('studentId name');
    if (!students.length) {
      return res.status(404).json({ message: 'No students found for this project ID' });
    }
    res.json(students);
  } catch (error) {
    console.error('Error fetching students:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

exports.getAttendanceDetails = async (req, res) => {
  const { projectId, date } = req.query;

  try {
    console.log('Fetching attendance for:', { projectId, date });
    
    // Format the date to match the database format (YYYY-MM-DD)
    const formattedDate = new Date(date).toISOString().split('T')[0];
    console.log('Formatted date:', formattedDate);

    // Find attendance for the given date and project
    const attendance = await Attendance.findOne({
      date: formattedDate,
      projectId: projectId
    });

    console.log('Found attendance:', attendance);

    if (!attendance) {
      return res.status(404).json({ message: 'No attendance found for this date' });
    }

    // Get all students for the project
    const students = await Student.find({ projectId });
    const studentMap = {};
    students.forEach(student => {
      studentMap[student.studentId] = student.name;
    });

    // Format the response
    const formattedAttendance = {
      date: attendance.date,
      projectId: attendance.projectId,
      periods: {}
    };

    // For each period, format the present/absent students with their names
    Object.entries(attendance.periods).forEach(([period, data]) => {
      formattedAttendance.periods[period] = {
        present: data.present.map(id => ({
          studentId: id,
          name: studentMap[id] || id
        })),
        absent: data.absent.map(id => ({
          studentId: id,
          name: studentMap[id] || id
        }))
      };
    });

    console.log('Formatted attendance response:', formattedAttendance);
    res.json(formattedAttendance);
  } catch (error) {
    console.error('Error fetching attendance details:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

exports.markAttendance = async (req, res) => {
  const { projectId, date, absentStudents, periods, isEdit = false } = req.body;

  try {
    console.log('Marking attendance with:', { projectId, date, absentStudents, periods, isEdit });
    
    // Format the date to match the database format (YYYY-MM-DD)
    const formattedDate = new Date(date).toISOString().split('T')[0];
    console.log('Formatted date:', formattedDate);

    // Get all students for the project
    const students = await Student.find({ projectId });
    const studentIds = students.map(student => student.studentId);

    // Check if attendance for the date exists
    let attendance = await Attendance.findOne({
      date: formattedDate,
      projectId: projectId
    });

    console.log('Existing attendance:', attendance);

    if (!attendance) {
      if (isEdit) {
        return res.status(404).json({ message: 'No attendance record found to edit' });
      }
      
      // Create new attendance record
      attendance = new Attendance({
        date: formattedDate,
        projectId,
        periods: {
          1: { present: [], absent: [] },
          2: { present: [], absent: [] },
          3: { present: [], absent: [] },
          4: { present: [], absent: [] },
          5: { present: [], absent: [] },
          6: { present: [], absent: [] },
          7: { present: [], absent: [] }
        }
      });
      console.log('Created new attendance record');
    } else {
      // Check if any of the selected periods are already marked
      const alreadyMarkedPeriods = periods.filter(period => {
        const periodData = attendance.periods[period];
        return periodData && (periodData.present.length > 0 || periodData.absent.length > 0);
      });

      if (alreadyMarkedPeriods.length > 0 && !isEdit) {
        return res.status(400).json({ 
          message: 'Some periods are already marked',
          markedPeriods: alreadyMarkedPeriods
        });
      }
    }

    // Update attendance for each period
    for (const period of periods) {
      const presentStudents = studentIds.filter(id => !absentStudents.includes(id));
      
      // For edits, we need to check the previous state
      if (isEdit) {
        const previousState = attendance.periods[period];
        
        // Update cumulative attendance for each student
        for (const student of students) {
          let cumulative = await CumulativeAttendance.findOne({ studentId: student.studentId });
          if (!cumulative) {
            cumulative = new CumulativeAttendance({
              studentId: student.studentId,
              sessionsHeld: 0,
              sessionsPresent: 0,
            });
          }

          const isAbsent = absentStudents.includes(student.studentId);
          const wasAbsent = previousState ? previousState.absent.includes(student.studentId) : false;
          
          if (wasAbsent && !isAbsent) {
            // Student was absent, now present
            cumulative.sessionsPresent += 1;
          } else if (!wasAbsent && isAbsent) {
            // Student was present, now absent
            cumulative.sessionsPresent -= 1;
          }
          
          await cumulative.save();
        }
      } else {
        // For new attendance, update cumulative attendance
        for (const student of students) {
          let cumulative = await CumulativeAttendance.findOne({ studentId: student.studentId });
          if (!cumulative) {
            cumulative = new CumulativeAttendance({
              studentId: student.studentId,
              sessionsHeld: 0,
              sessionsPresent: 0,
            });
          }

          const isAbsent = absentStudents.includes(student.studentId);
          cumulative.sessionsHeld += 1;
          if (!isAbsent) {
            cumulative.sessionsPresent += 1;
          }
          
          await cumulative.save();
        }
      }

      // Update the period's attendance
      attendance.periods[period] = {
        present: presentStudents,
        absent: absentStudents
      };
    }

    await attendance.save();
    console.log('Saved attendance:', attendance);

    res.status(200).json({ message: 'Attendance marked successfully' });
  } catch (error) {
    console.error('Error marking attendance:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

exports.getStudentAttendance = async (req, res) => {
  const { studentId } = req.params;

  try {
    const cumulative = await CumulativeAttendance.findOne({ studentId });
    if (!cumulative) {
      return res.status(404).json({ message: 'No attendance data' });
    }

    res.json({
      studentId,
      sessionsHeld: cumulative.sessionsHeld,
      sessionsPresent: cumulative.sessionsPresent,
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

exports.checkAttendance = async (req, res) => {
  const { projectId, date } = req.query;

  try {
    console.log('Checking attendance for:', { projectId, date });
    
    // Format the date to YYYY-MM-DD
    const formattedDate = new Date(date).toISOString().split('T')[0];
    console.log('Formatted date:', formattedDate);

    const attendance = await Attendance.findOne({
      date: formattedDate,
      projectId
    });

    if (!attendance) {
      console.log('No attendance record found');
      return res.json({ markedPeriods: [] });
    }

    console.log('Found attendance record:', attendance);

    // Check each period to see if it has any attendance data
    const markedPeriods = [];
    for (let period = 1; period <= 7; period++) {
      const periodData = attendance.periods[period];
      if (periodData && (periodData.present.length > 0 || periodData.absent.length > 0)) {
        markedPeriods.push(period);
      }
    }

    console.log('Marked periods:', markedPeriods);
    res.json({ markedPeriods });
  } catch (error) {
    console.error('Error checking attendance:', error);
    res.status(500).json({ message: 'Server error' });
  }
};