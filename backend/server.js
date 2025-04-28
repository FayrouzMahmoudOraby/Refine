const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const app = express();

// Rate Limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100,
});
app.use(limiter);

// Middleware
app.use(helmet());
app.use(cors({
  origin: 'http://localhost:5000', // your Flutter Web or app dev URL
  credentials: true,
}));
app.use(express.json());

// Routes
const userRoutes = require('./routes/users');
const videoRoutes = require('./routes/videoRoutes');
const coachPlayersRoutes = require('./routes/coachplayerRoute');
app.use('/api/coachplayers', coachPlayersRoutes);
app.use('/api/users', userRoutes);
app.use('/api/videos', videoRoutes);

// MongoDB Connection
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('MongoDB connected'))
.catch((err) => console.error('MongoDB connection error:', err));

// Server Start
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));