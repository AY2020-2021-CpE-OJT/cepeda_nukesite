const mongoose = require('mongoose');

const profileSchema = new mongoose.Schema({
	user: String,
	note: String
});

module.exports = mongoose.model('Profile', profileSchema);