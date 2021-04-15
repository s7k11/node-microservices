const { expect } = require('chai');

require('it-each')({ testPerIteration: true });
const { LOGIN_DTO_SCHEMA: loginSchema } = require('../../../constant');

const Validator = require('../../../../utils/validator');

describe('Validator module', () => {
  describe('isValidUuid method', () => {
    it('should exists inside validation module', () => {
      expect(Validator.isValidUuid).to.be.exist;
    });

    it('should return true for a valid UUID value', () => {
      const isValid = Validator.isValidUuid('9498fd21-e175-401a-a143-914e2582f4f2');

      expect(isValid).equal(true);
    });

    it('should return false for an invalid UUID value', () => {
      const isValid = Validator.isValidUuid('aasdvgsgdgscvsgcgvscgv#@#$acaCDFDXACX');

      expect(isValid).equal(false);
    });
  });

  describe('isSchemaValid method', () => {
    it('should exists inside the validation module', () => {
      expect(Validator.isSchemaValid).to.be.exist;
    });

    it('should validate the user registration request data', () => {
      const { errors } = Validator.isSchemaValid({
        schema: loginSchema,
        data: { userName: 'test@email.com', password: 'test' },
      });

      expect(errors).to.deep.equal();
    });

    it('should return validation error msg if "userName" field is required', () => {
      const { errors } = Validator.isSchemaValid({
        schema: loginSchema,
        data: { password: 'test' },
      });

      expect(errors).to.deep.equal([ { name: 'type', message: 'should NOT have fewer than 2 items' },
        { name: 'userName', message: 'UserName is required in the body.' } ]);
    });
  });
});
