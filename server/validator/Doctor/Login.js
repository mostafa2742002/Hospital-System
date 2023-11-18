const Joi = require( "joi" );
const Doctor = require( "../../models/Doctor" );
const bcrypt = require( "bcryptjs" );

const Login_Validator = Joi.object( {
  email: Joi.string().email().required(),
  password: Joi.string().min( 6 ).required(),
} );

test = async function ( data )
{
  const { error } = Login_Validator.validate( data );

  // check if the email is exist
  let founded = await Doctor.findOne( { email: data.email } );
  if ( !founded )
  {
    return [ "Email is not exist", 401 ];
  }

  // const passwordMatch = await bcrypt.compare( data.password, founded.password );
  // console.log( data.password, founded.password );
  // if ( !passwordMatch )
  // {
  //   return [ "Password is wrong", 401 ];
  // }


  return [ "valid", 200 ];

};

module.exports = test;
