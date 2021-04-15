const chai = require('chai');
const chaiHttp = require('chai-http');

const server = require('../../server');
const { VERSION, NAME } = require('../../config');

const { expect } = chai;

chai.use(chaiHttp);

describe('Ping /GET', () => {
  it('should return response status equals to 200', async () => {
    const { status } = await chai.request(server).get('/ping');

    expect(status).to.deep.equal(200);
  });

  it('should return response body containing status `ok` and latest version of build', async () => {
    const { body } = await chai.request(server).get('/ping');

    expect(body).to.deep.equal({ status: 'ok', version: VERSION, name: NAME });
  });
});
