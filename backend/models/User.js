const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        unique: true, // Ensure email is unique
        match: [/^\S+@\S+\.\S+$/, 'Please enter a valid email address'], // Email validation
    },
    role: {
        type: String,
        enum: ['coach', 'player'], // Only allow 'coach' or 'player'
        required: true,
    },
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
