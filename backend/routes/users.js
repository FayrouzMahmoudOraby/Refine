const express = require('express');
const router = express.Router();
const User = require('../models/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const auth = require('../middleware/auth');

// Load secret from .env
const JWT_SECRET = process.env.JWT_SECRET;

// ✅ SIGN UP
router.post('/', async (req, res) => {
  try {
    const existingUser = await User.findOne({ email: req.body.email });
    if (existingUser) return res.status(400).json({ error: 'Email already exists' });

    const newUser = new User(req.body);
    await newUser.save();

    res.status(201).json({ message: 'User created successfully', user: newUser });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ error: 'Invalid email or password' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ error: 'Invalid email or password' });

    const token = jwt.sign({ id: user._id, role: user.role }, JWT_SECRET, { expiresIn: '1d' });

    res.status(200).json({ 
      success: true,
      message: 'Login successful', 
      token, 
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role
      } 
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
// Protected route example
router.get('/me', auth, (req, res) => {
  res.json({ message: 'Protected data', user: req.user });
});
router.get('/players', async (req, res) => {
  try {
    const players = await User.find({ role: 'player' });
    res.status(200).json(players);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
});
// Add these routes to your users.js

// Get current user profile
router.get('/me', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password');
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update user profile
// Update the profile update route to handle password changes
router.put('/me', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ error: 'User not found' });

    // Prepare updates
    const updates = {
      name: req.body.name,
      email: req.body.email,
    };

    // Handle password change only if new password is provided
    if (req.body.newPassword) {
      if (!req.body.currentPassword) {
        return res.status(400).json({ 
          success: false,
          error: 'Current password is required to change password' 
        });
      }

      // Verify current password
      const isMatch = await bcrypt.compare(req.body.currentPassword, user.password);
      if (!isMatch) {
        return res.status(400).json({ 
          success: false,
          error: 'Current password is incorrect' 
        });
      }

      // Hash and update new password
      const salt = await bcrypt.genSalt(10);
      updates.password = await bcrypt.hash(req.body.newPassword, salt);
    }

    // Update user
    const updatedUser = await User.findByIdAndUpdate(
      req.user.id,
      { $set: updates },
      { new: true }
    ).select('-password');

    res.json({
      success: true,
      user: updatedUser
    });
  } catch (err) {
    res.status(400).json({ 
      success: false,
      error: err.message 
    });
  }
});
module.exports = router;