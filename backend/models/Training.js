const mongoose = require('mongoose');

const trainingSchema = new mongoose.Schema({
  playerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  date: {
    type: Date,
    required: true,
  },
  duration: {
    type: String, // you can also use Number if it's in minutes
    required: true,
  }
}, { timestamps: true });

module.exports = mongoose.model('Training', trainingSchema);
