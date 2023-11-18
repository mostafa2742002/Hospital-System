const Doctor = require( "../../models/Doctor" );
const sendResponse = require( "../../utils/sendResonse" );

const DeleteDoctor = async ( req, res ) =>
{
  try
  {
    const email = req.body.email;
    const doctor = await Doctor.findOneAndDelete( { email: email } );
    if ( !doctor )
    {
      return sendResponse( res, 404, "Doctor not found" );
    }
    return sendResponse( res, 200, "Doctor has been deleted successfully" );

  } catch ( err )
  {
    console.log( err );
    return sendResponse( res, 500, "Internal Server Error" );
  }
};

module.exports = { DeleteDoctor };