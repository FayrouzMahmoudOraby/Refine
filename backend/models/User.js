const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  lastName: { type: String },
  email: {
    type: String,
    required: true,
    unique: true,
    match: [/^\S+@\S+\.\S+$/, 'Please enter a valid email address'],
  },
  password: { type: String, required: true },
  phone: { type: String },
  // In your user model (models/User.js)
  role: {
    type: String,
    enum: ['coach', 'player', 'admin'],  // Added 'admin'
    required: true,
  }
}, { timestamps: true });

userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});
// Add this method to your User model
userSchema.methods.updateProfile = async function(updates) {
  const updatesKeys = Object.keys(updates);
  
  updatesKeys.forEach(key => {
    if (key === 'password') return; // Handle password separately
    this[key] = updates[key];
  });
  
  if (updates.password) {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(updates.password, salt);
  }
  
  await this.save();
  return this;
};

module.exports = mongoose.model('User', userSchema);