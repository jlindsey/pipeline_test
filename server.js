var connect = require('connect'),
		port		= process.env.PORT || 5000;

connect.createServer(connect.static('public')).listen(port);
console.log("Listening on port " + port);
