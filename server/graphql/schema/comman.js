module.exports = `
type error{
    name: String!
    message: String! 
  }
  
  type result{
    errors: [ error ]
    publicId: String
    message:String
  }
`;
