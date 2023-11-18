const Patient = require( "../../models/Patient" );
const sendResponse = require( "../../utils/sendResonse" );


const UpdatePatient = async ( req, res ) =>
{
    try
    {



        // get the doctor
        const doctor = await Patient.findOne( { email: req.body.email } );

        // update the doctor
        doctor.fullname = req.body.fullname;
        doctor.email = req.body.email;
        doctor.password = req.body.password;
        // doctor.gender = req.body.gender;

        doctor.phone = req.body.phone;
        doctor.photo = req.body.photo;
        // doctor.aboutDoctor = req.body.aboutDoctor;
        // doctor.address = req.body.address;
        // doctor.price = req.body.price;
        doctor.age = req.body.age;


        await doctor.save();

        // send the response
        return sendResponse( res, 200, "Doctor has been updated successfully" );
    }
    catch ( err )
    {
        console.log( err );
        return sendResponse( res, 500, "Internal Server Error" );
    }
}

module.exports = { UpdatePatient };