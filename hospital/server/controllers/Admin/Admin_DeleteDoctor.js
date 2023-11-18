const Doctor = require( "../../models/Admin" );
const sendResponse = require( "../../utils/sendResonse" );

const DeleteDoctor = async ( req, res ) =>
{
  try
  {
    const id = req.body.email;
    console.log( id );
    const doctor = await Doctor.findOneAndDelete( { email: id } );
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