const bcrypt = require( "bcryptjs" );
const jwt = require( "jsonwebtoken" );
const Appointment = require( "../../models/appointment" );

const key = "mostafa_eman_eman_menna_hasnaa";
const sendResponse = require( "../../utils/sendResonse" );

const GetAppointments = async ( req, res ) =>
{
    try
    {
        const { id } = req.body;
        // console.log(id);
        const appointments = await Appointment.find( { patientId: id } );
        // console.log(appointments);
        return sendResponse( res, 200, "Appointments", appointments );
    }
    catch ( err )
    {
        console.log( err );
        return sendResponse( res, 500, "Internal Server Error" );
    }
};


module.exports = { GetAppointments };