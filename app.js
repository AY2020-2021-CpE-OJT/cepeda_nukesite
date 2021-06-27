const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

const app = express();

// <<<<<<<<<<<<<<<< DATABASE >>>>>>>>>>>>>>>>> //
mongoose.connect('mongodb://localhost/nukesite3', {
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
	res.send("Hello, World!");
});

const reroute = require('./routes/routes');
app.use('/',reroute);

// Starting server
app.listen(2077, console.log("Eavesdropping at Port 2077"));