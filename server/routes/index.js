const express = require('express');

const router = express.Router();

const pingRoutes = require('./ping.js');
const healthCheckRoutes = require('./health-check');
const apiSpecRoutes = require('./api-spec');

pingRoutes(router);
healthCheckRoutes(router);
apiSpecRoutes(router);

module.exports = router;
