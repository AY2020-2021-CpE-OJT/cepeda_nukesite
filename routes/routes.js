const express = require('express');
const router = express.Router();
const Profile = require('../models/profile');
var mongodb = require("mongodb");
// <<<<<<<<<<<<<<<< TESTS >>>>>>>>>>>>>>>>> //
router.get('/reee', (req, res) => {
	res.send("reee");
});

router.get('/nuke', (req, res) => {
	res.send("3...2...1...");
});
// <<<<<<<<<<<<<<<< ADD NEW >>>>>>>>>>>>>>>>> //
router.post('/new', async (req, res) => {
	const newProfile = new Profile(req.body);
	const savedProfile = await newProfile.save();
	res.json(savedProfile);
});
// <<<<<<<<<<<<<<<< SEARCH VIA ID >>>>>>>>>>>>>>>>> //
router.get("/get/:id", async (req, res) => {
    const foundProfile = await Profile.findById({ _id: req.params.id });
    res.json(foundProfile);
});
// <<<<<<<<<<<<<<<< DELETE VIA ID >>>>>>>>>>>>>>>>> //
router.delete('/delete/:id', async (req, res) => {
	const foundProfile = await Profile.findByIdAndDelete({ _id: req.params.id });
    res.json(foundProfile);
});
// <<<<<<<<<<<<<<<< UPDATE VIA ID >>>>>>>>>>>>>>>>> //
router.patch('/update/:id', async (req, res) => {
	const q = await Profile.updateOne({_id: req.params.id}, {$set: req.body});
	res.json(q);
});
// <<<<<<<<<<<<<<<< FIND ALL >>>>>>>>>>>>>>>>> //
router.get('/all', async (req, res) => {
	const profile = await Profile.find();
	res.json(profile);
});
// <<<<<<<<<<<<<<<< SEARCH NAMES >>>>>>>>>>>>>>>>> //
router.get('/search/:via', function(req,res){
    var regex = new RegExp(req.params.via, 'i');  // 'i' makes it case insensitive
    return Profile.find({user: regex}, function(err,profile){
        return res.send(profile);
    });
});

module.exports = router;