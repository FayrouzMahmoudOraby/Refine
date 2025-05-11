const express = require('express');
const router = express.Router();
const Training = require('../models/Training');
const User = require('../models/User'); // Add User model import

// POST - Create new training
router.post('/', async (req, res) => {
  try {
    const { email, title, date, duration } = req.body;

    // Validate all fields
    if (!email || !title || !date || !duration) {
      return res.status(400).json({ 
        message: 'All fields are required',
        fields: { email, title, date, duration }
      });
    }

    // Find user by email first
    const user = await User.findOne({ email: email.toLowerCase().trim() });
    if (!user) {
      return res.status(404).json({ message: 'User not found with this email' });
    }

    // Create training with both email and user reference
    const training = new Training({ 
      email: email.toLowerCase().trim(),
      title: title.trim(),
      date,
      duration: duration.trim(),
      user: user._id 
    });

    await training.save();

    res.status(201).json({
      ...training.toObject(),
      userDetails: {
        name: user.name,
        email: user.email
      }
    });
    
  } catch (error) {
    console.error('Training creation error:', error);
    res.status(500).json({ 
      message: 'Server error',
      error: error.message 
    });
  }
});

module.exports = router;