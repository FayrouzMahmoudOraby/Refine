const express = require('express');
const router = express.Router();
const User = require('../models/User');

// Get all users (admins and coaches only)
router.get('/users', async (req, res) => {
  try {
    const users = await User.find({
      role: { $in: ['admin', 'coach'] } // Only fetch admins/coaches
    }).select('-password');
    
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Add new user (admin or coach)
router.post('/users', async (req, res) => {
  try {
    const { name, email, password, role } = req.body;

    // Validate role
    if (!['admin', 'coach'].includes(role)) {
      return res.status(400).json({ error: 'Invalid role' });
    }

    // Check if user exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: 'Email already exists' });
    }

    // Create new user
    const newUser = new User({
      name,
      email,
      password,
      role
    });

    await newUser.save();
    res.status(201).json(newUser);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete user (admin or coach)
router.delete('/users/:id', async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    
    // Prevent deleting players
    if (user.role === 'player') {
      return res.status(403).json({ error: 'Cannot delete players' });
    }

    await User.findByIdAndDelete(req.params.id);
    res.json({ message: 'User deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;