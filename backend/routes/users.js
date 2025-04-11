const express = require('express');
const router = express.Router();
const User = require('../models/User'); // Assuming your User model is correct

// POST - Create a new user
router.post('/', async (req, res) => {
    try {
        // Check if user already exists
        const existingUser = await User.findOne({ email: req.body.email });
        if (existingUser) {
            return res.status(400).json({ error: 'Email already exists' });
        }

        // Create new user
        const newUser = new User(req.body); // Assuming req.body has correct data

        // Save the user to the database
        await newUser.save();

        // Send success response with created user
        res.status(201).json(newUser);
    } catch (err) {
        // Send error response if something goes wrong
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
