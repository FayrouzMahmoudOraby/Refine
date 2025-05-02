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

// ✅ LOGIN
// In your login route (routes/users.js)
// In your users route (routes/users.js)
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

module.exports = router;