const { mergeTypeDefs } = require('@graphql-tools/merge');

const Scaler = require('./scaler');
const Comman = require('./comman');

const types = [
  Comman,
  Scaler,
];

module.exports = mergeTypeDefs(types);
