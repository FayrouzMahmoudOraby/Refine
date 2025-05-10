const express = require('express');
const router = express.Router();
const Training = require('../models/Training');

// POST - Create new training
router.post('/', async (req, res) => {
  try {
    const { playerId, title, date, duration } = req.body;

    if (!playerId || !title || !date || !duration) {
      return res.status(400).json({ message: 'All fields are required' });
    }

    const training = new Training({ playerId, title, date, duration });
    await training.save();

    res.status(201).json(training);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
});

module.exports = router;
