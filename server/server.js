const express = require('express');
const cors = require('cors');
const compression = require('compression');
const helmet = require('helmet');
require('dotenv').config()
const { graphqlHTTP } = require('express-graphql');

const SmartHttp = require('smart-http');

const { schema, root } = require('./graphql');

const routes = require('./routes');

const { PORT } = require('./config');

const server = express();

/**
 * Start the app by listening <port>
 * */
const app = server.listen(PORT);

/**
 * List of all middlewares used in project cors, compression, helmet
 * */
try {
  // only if you're behind a reverse proxy (Heroku, Bluemix, AWS ELB, Nginx, etc)
  server.enable('trust proxy');
  server.use(SmartHttp());

  server.use(cors({
    exposedHeaders: [ 'token', 'slug', 'message', 'set-password', 'password', 'is-password-already-set', 'public-id', 'x-coreplatform-paging-limit',
      'x-coreplatform-total-records', 'x-coreplatform-concurrencystamp' ],
  }));
  server.use(compression());
  server.use(helmet());
  server.use(express.urlencoded({
    extended: true,
  }));
  server.use(express.json());

  server.use('/graphql', graphqlHTTP((req) => ({
    schema,
    rootValue: root,
    graphiql: true,
    pretty: true,
    context: {
      user: req.user,
      headers: req.headers,
    },
  })));

  server.use('/', routes);
} catch (e) {
  app.close();
}

module.exports = server;
