const mongoose = require('mongoose');

const coach_playersSchema = new mongoose.Schema({
    name: 
    {
        type: String,
        required:true
    },
    age:
    {
        type: String,
        required:true
    },
    description:
    {
        type: String,
        required: true
    }
});

module.exports = mongoose.model('Coach_Players', coach_playersSchema);
