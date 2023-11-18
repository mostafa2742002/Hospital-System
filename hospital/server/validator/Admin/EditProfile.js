const Joi = require( "joi" );
const Admin = require( "../../models/Admin" );

const Edit_Validator = Joi.object( {
  fullname: Joi.string().min( 6 ).required(),
  email: Joi.string().email().required(),
  password: Joi.string().min( 6 ).required(),
  confirmPassword: Joi.string().min( 6 ).required().valid( Joi.ref( "password" ) ),
  photo: Joi.string().required(),
} );

test = async function ( data )
{
  const { error } = Edit_Validator.validate( data );

  if ( error )
  {
    return [ error.details[ 0 ].message, 400 ];
  } else
  {
    return [ "valid", 200 ];
  }
};

module.exports = test;
