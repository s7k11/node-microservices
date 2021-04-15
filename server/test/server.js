const express = require('express');
const cors = require('cors');
const compression = require('compression');
const helmet = require('helmet');
const NodeHttp = require('smart-http');

const routes = require('../routes');

const server = express();

server.enable('trust proxy');
server.use(NodeHttp());

server.use(cors({
  exposedHeaders: [ 'token' ],
}));

server.use(compression());
server.use(helmet());
server.use(express.urlencoded({
  extended: true,
}));
server.use(express.json());

server.use('/', routes);

module.exports = {
  server,
};
