const express = require('express');
const multer = require('multer');
const ffmpeg = require('fluent-ffmpeg');
const path = require('path');
const fs = require('fs');
const axios = require('axios');
const FormData = require('form-data');
const Report = require('../models/Report');
const { OpenAI } = require('openai');

const router = express.Router();

// Configure multer for disk storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null,'/uploads'),
  filename: (req, file, cb) => cb(null, `${Date.now()}-${file.originalname}`)
});

const upload = multer({ storage });

// Initialize OpenAI
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

//function Video chunks 
function splitVideoToChunks(inputPath, outputDir, chunkDuration = 60) {
  return new Promise((resolve, reject) =>{
    if(!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, {recursive: true});

    ffmpeg(inputPath).outputOption([
      '-codec copy',
      '-map 0',
      '-f segment',
      `-segment_time ${chunkDuration}`,
      '-rest_timestamps 1',
    ])
      .output(path.join(outputDir, 'chunk_%03d.mp4'))
      .on('end',() => {
        const chunks = fs.readdirSync(outputDir)
          .filter(file => file.endsWith('mp4'))
          .map(file => path.join(outputDir, file));
        resolve(chunks);
      })
      .on('error', reject)
      .run();
  });
}

//send chunk to fastapi
async function sendChunkTpFTAPI(chunkPath){
  const formData = new FormData();
  formData.append('file', fs.createReadStream(chunkPath));

  const response = await axios.post(process.env.AI_API_ENDPOINT, formData, {
    headers: formData.getHeaders(),
  });
  
  return response.data;
}

// Enhanced video upload route with ChatGPT integration
router.post('/upload', upload.single('video'), async (req, res) => {
  try {
    // const videoFile = req.file;
    const userId = req.body.userId;
    const videoPath = req.file.path;
    const chunkDir = `chunks/${Date.now()}`;

    if (!videoFile) {
      return res.status(400).json({ error: 'No video file uploaded' });
    }

    //step 1: Split video into chunks
    const chunkPaths = await splitVideoToChunks(videoPath, chunkDir, 60);

    // Step 2: Analyze each chunk
    const allAnalyses = [];
    for (const chunk of chunkPaths) {
      const result = await sendChunkTpFTAPI(chunk);
      allAnalyses.push(result);
    }
    
    // Step 3: Send analysis to ChatGPT for feedback
    const chatGPTPrompt = `
    You are a tennis movement analysis expert. Below is a JSON analysis of a tennis player's movement.
    Please provide detailed feedback on their technique, including:
    - What they're doing correctly
    - Areas for improvement
    - Specific drills or exercises to address issues
    - Any safety concerns about their form
    
    Analysis Data:
    ${JSON.stringify(allAnalyses, null, 2)}
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
      videoUrl: videoPath,
      analysis: allAnalyses,
      chatGPTFeedback: feedback,
      timestamp: new Date()
    });
    await report.save();

    // Step 5: Return both analysis and feedback to frontend
    res.status(200).json({
      message: 'Analysis complete',
      technicalAnalysis: allAnalyses,
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