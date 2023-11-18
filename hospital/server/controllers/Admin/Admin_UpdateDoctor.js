const Doctor = require( "../../models/Doctor" );
const sendResponse = require( "../../utils/sendResonse" );
const checkFile = require( "../../validator/Doctor/UpdateData" );

const UpdateDoctor = async ( req, res ) =>
{
    try
    {

        // const error = await checkFile(req.body);
        // if(error[0] !== "valid"){
        //     return sendResponse(res, error[1], error[0]);
        // }
        /**
         * 'email': email,
        'password': password,
        'fullname': name,
        'gender': gender,
        'Specialization': specialization,
        'phone': phone,
        'photo': base64Image,
        'aboutDoctor': aboutDoctor,
        'address': address,
        'token': token,
        'id': id,
        'Price': price,
        'age': age,
         */

        // get the doctor
        const doctor = await Doctor.findOne( { email: req.body.email } );

        // update the doctor
        doctor.name = req.body.name;
        doctor.email = req.body.email;
        doctor.password = req.body.password;
        doctor.gender = req.body.gender;
        doctor.Specialization = req.body.Specialization;
        doctor.phone = req.body.phone;
        doctor.photo = req.body.photo;
        doctor.aboutDoctor = req.body.aboutDoctor;
        doctor.address = req.body.address;
        doctor.price = req.body.price;
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

module.exports = { UpdateDoctor };