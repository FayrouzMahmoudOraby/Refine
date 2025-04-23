const express = require('express');
const multer = require('multer');
const axios = require('axios');
const FormData = require('form-data');
const Report = require('../models/Report');

const router = express.Router();

// Configure Multer for file uploads
const storage = multer.memoryStorage();
const upload = multer({ storage });

// Video upload route
router.post('/upload', upload.single('video'), async (req, res) => {
    try {
        const videoFile = req.file; // Uploaded video file
        const userId = req.body.userId; // User ID from the app

        if (!videoFile) {
            return res.status(400).json({ error: 'No video file uploaded' });
        }

        // Create a FormData object to send to the AI API
        const formData = new FormData();
        formData.append('file', videoFile.buffer, {
            filename: videoFile.originalname,
            contentType: videoFile.mimetype,
        });

        // Forward the video to the AI API
        const aiApiResponse = await axios.post(process.env.AI_API_ENDPOINT, formData, {
            headers: { ...formData.getHeaders() }, // Include multipart/form-data headers
        });

        // Save the analysis in MongoDB
        const report = new Report({
            userId,
            videoUrl: `uploads/${videoFile.originalname}`, // Optional: Store video URL if needed
            analysis: aiApiResponse.data.player, // AI API's analysis result
        });
        await report.save();

        // Respond to the Flutter app with the AI API's analysis
        res.status(200).json({
            message: 'Analysis complete',
            report: aiApiResponse.data.player,
        });
    } catch (error) {
        console.error('Error processing video:', error);
        res.status(500).json({ error: 'Failed to process video' });
    }
});

module.exports = router;