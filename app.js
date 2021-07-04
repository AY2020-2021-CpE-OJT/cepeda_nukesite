const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

const app = express();

// <<<<<<<<<<<<<<<< DATABASE >>>>>>>>>>>>>>>>> //
const localHost = 'mongodb://localhost/nukesite3';
const remoteHost = 'mongodb+srv://nobody:nuke3@local-cluster.ufwwa.mongodb.net/nukeTest';
mongoose.connect(localHost, {
	useNewUrlParser: true,
	useUnifiedTopology: true
});

const db = mongoose.connection;

db.once('open', () => {
	console.log("MongoDB Connected");
});
// <<<<<<<<<<<<<<<< MIDWARE >>>>>>>>>>>>>>>>> //
app.use(bodyParser.json());

// <<<<<<<<<<<<<<<< ROUTES >>>>>>>>>>>>>>>>> //

app.get('/', (req, res) => {
	res.send("THIS IS VERSION 4");
});

const reroute = require('./routes/routes');
app.use('/',reroute);

// Starting server
app.listen(2077, console.log("Eavesdropping at Port 2077"));