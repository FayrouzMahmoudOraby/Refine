const mongoose = require('mongoose');

const reportSchema = new mongoose.Schema({
    userId: { type: String, required: true },
    videoUrl: { type: String, required: true },
    analysis: { type: Object, required: true },
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Report', reportSchema);