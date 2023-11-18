const sendResponse = require( "../utils/sendResonse" );
const Doctor = require( "../models/Doctor" );
module.exports = async ( req, res, next ) =>
{
  try
  {
    console.log( "emz" );
    console.log( req.body._id );
    const doctor = await Doctor.findById( { _id: req.body._id } );
    if ( !doctor )
    {
      return sendResponse( res, 404, "The doctor is not found" );
    }
    next();
  } catch ( err )
  {
    return sendResponse( res, 500, "Something went wrong" );
  }
};


