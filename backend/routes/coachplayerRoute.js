const express = require('express');
const router = express.Router();
const CoachPlayers = require('../models/CoachPlayer');

// Create a new player
router.post('/', async (req, res) => {
    try {
        const newPlayer = new CoachPlayers(req.body);
        const savedPlayer = await newPlayer.save();
        res.json(savedPlayer);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Get all players
router.get('/', async (req, res) => {
    try {
        const players = await CoachPlayers.find();
        res.json(players);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Get one player by ID
router.get('/:id', async (req, res) => {
    try {
        const player = await CoachPlayers.findById(req.params.id);
        if (!player) return res.status(404).json({ message: 'Player not found' });
        res.json(player);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Update a player by ID
router.put('/:id', async (req, res) => {
    try {
        const updatedPlayer = await CoachPlayers.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }
        );
        res.json(updatedPlayer);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Delete a player by ID
router.delete('/:id', async (req, res) => {
    try {
        await CoachPlayers.findByIdAndDelete(req.params.id);
        res.json({ message: 'Player deleted' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;
