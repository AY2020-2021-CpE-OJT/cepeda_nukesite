const express = require('express');
const router = express.Router();
const Contact = require('../models/contact');
var mongodb = require("mongodb");
// <<<<<<<<<<<<<<<< TESTS >>>>>>>>>>>>>>>>> //
router.get('/test', (req, res) => {
	res.send("test");
});
// <<<<<<<<<<<<<<<< ADD NEW >>>>>>>>>>>>>>>>> //
router.post('/new', async (req, res) => {
	const newContact = new Contact(req.body);
	const savedContact = await newContact.save();
	res.json(savedContact);
});
// <<<<<<<<<<<<<<<< SEARCH VIA ID >>>>>>>>>>>>>>>>> //
router.get("/get/:id", async (req, res) => {
    const foundContact = await Contact.findById({ _id: req.params.id });
    res.json(foundContact);
});
// <<<<<<<<<<<<<<<< DELETE VIA ID >>>>>>>>>>>>>>>>> //
router.delete('/delete/:id', async (req, res) => {
	const foundContact = await Contact.findByIdAndDelete({ _id: req.params.id });
    res.json(foundContact);
});
// <<<<<<<<<<<<<<<< UPDATE VIA ID >>>>>>>>>>>>>>>>> //
router.patch('/update/:id', async (req, res) => {
	const q = await Contact.updateOne({_id: req.params.id}, {$set: req.body});
	res.json(q);
});
// <<<<<<<<<<<<<<<< FIND ALL >>>>>>>>>>>>>>>>> //
router.get('/all', async (req, res) => {
	const contact = await Contact.find();
	res.json(contact);
});
// <<<<<<<<<<<<<<<< SEARCH NAMES >>>>>>>>>>>>>>>>> //
router.get('/search/:via', function(req,res){
    var regex = new RegExp(req.params.via, 'i');  // 'i' makes it case insensitive
    return Contact.find( { $or: [ {first_name: regex} , {last_name: regex} ] }, function(err,contact){
        return res.send(contact);
    });
});

module.exports = router;