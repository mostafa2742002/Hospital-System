const Doctor = require( "../../models/Doctor" );
const sendResponse = require( "../../utils/sendResonse" );

const ReadDoctorsData = async ( req, res ) =>
{
    try
    {
        const doctors = await Doctor.find();
        if ( doctors.length === 0 )
        {
            return sendResponse( res, 404, "No Doctors Found" );
        }
        console.log( doctors );
        return sendResponse( res, 200, "All Doctors", doctors );
    }
    catch ( err )
    {
        console.log( err );
        return sendResponse( res, 500, "Internal Server Error" );
    }
}

module.exports = { ReadDoctorsData };
