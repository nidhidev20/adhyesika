const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const Student = require('../models/student');
const Faculty = require('../models/faculty');
const Admin = require('../models/admin');

exports.login = async (req, res) => {
  const { id, password, role } = req.body;
  let user;

  try {
    if (role === 'student') {
      user = await Student.findOne({ studentId: id });
    } else if (role === 'faculty') {
      user = await Faculty.findOne({ facultyId: id });
    } else if (role === 'admin') {
      user = await Admin.findOne({ adminId: id });
    }

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign({ id: user[role + 'Id'] || user.adminId, role }, 'secret', { expiresIn: '1h' });
    res.json({
      token,
      user: {
        id: user[role + 'Id'] || user.adminId,
        role,
        name: user.name,
        year: user.year,
        projectId: user.projectId,
        department: user.department,
        facultyId: user.facultyId,
      },
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};