const express = require('express');
const multer = require('multer');
const axios = require('axios');
const FormData = require('form-data');
const Report = require('../models/Report');
const { OpenAI } = require('openai');

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

// Initialize OpenAI
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

// Enhanced video upload route with ChatGPT integration
router.post('/upload', upload.single('video'), async (req, res) => {
  try {
    const videoFile = req.file;
    const userId = req.body.userId;

    if (!videoFile) {
      return res.status(400).json({ error: 'No video file uploaded' });
    }

    // Step 1: Send video to AI analysis API
    const formData = new FormData();
    formData.append('file', videoFile.buffer, {
      filename: videoFile.originalname,
      contentType: videoFile.mimetype,
    });

    const aiApiResponse = await axios.post(process.env.AI_API_ENDPOINT, formData, {
      headers: { ...formData.getHeaders() },
    });

    // Step 2: Get the analysis JSON from AI API
    const analysisData = aiApiResponse.data.player;
    
    // Step 3: Send analysis to ChatGPT for feedback
    const chatGPTPrompt = `
    You are a tennis movement analysis expert. Below is a JSON analysis of a tennis player's movement.
    Please provide detailed feedback on their technique, including:
    - What they're doing correctly
    - Areas for improvement
    - Specific drills or exercises to address issues
    - Any safety concerns about their form
    
    Analysis Data:
    ${JSON.stringify(analysisData, null, 2)}
    `;

    const chatResponse = await openai.chat.completions.create({
      model: "gpt-4",
      messages: [
        {
          role: "system",
          content: "You are a professional tennis coach with 20 years of experience analyzing player movements."
        },
        {
          role: "user",
          content: chatGPTPrompt
        }
      ],
      temperature: 0.7,
    });

    const feedback = chatResponse.choices[0].message.content;

    // Step 4: Save everything to database
    const report = new Report({
      userId,
      videoUrl: `uploads/${videoFile.originalname}`,
      analysis: analysisData,
      chatGPTFeedback: feedback,
      timestamp: new Date()
    });
    await report.save();

    // Step 5: Return both analysis and feedback to frontend
    res.status(200).json({
      message: 'Analysis complete',
      technicalAnalysis: analysisData,
      coachFeedback: feedback
    });

  } catch (error) {
    console.error('Error processing video:', error);
    if (error.response) {
      return res.status(error.response.status || 500).json({
        error: 'AI API Error',
        details: error.response.data,
      });
    }
    return res.status(500).json({ 
      error: 'Failed to process video',
      details: error.message 
    });
  }
});

module.exports = router;