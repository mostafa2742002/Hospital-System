const express = require( "express" );
const app = express();
const verificationCodes = {};
const bcrypt = require( "bcryptjs" );
const http = require( "http" );
const nodemailer = require( 'nodemailer' );
const server = http.createServer( app );
const { Server } = require( "socket.io" );
const io = new Server( server );
const port = process.env.PORT || 3000;

const morgan = require( "morgan" );
app.use( morgan( "dev" ) );

const cors = require( "cors" );
app.use( cors() );

require( "./connection/mongoose" );

const bodyParser = require( "body-parser" );
app.use( bodyParser.json( { limit: '10mb' } ) );


app.use( bodyParser.urlencoded( { limit: '10mb', extended: true } ) );
const Uploadd = require( "express-fileupload" );
app.use( Uploadd() );

const Patient = require( "./routes/patient" );
const Doctor = require( "./routes/doctor" );
const Admin = require( "./routes/Admin" );

app.use( "/patient", Patient );
app.use( "/doctor", Doctor );
app.use( "/admin", Admin );

const DoctorModel = require( "./models/Doctor" );
const PatientModel = require( "./models/Patient" );
const sendResponse = require( "./utils/sendResonse" );

app.post( '/forgotPassword', async ( req, res ) =>
{
  const email = req.body.email;
  const type = DoctorModel.findOne( { email: email } ) ? 'doctor' : 'patient';

  if ( type === 'doctor' )
  {
    try
    {
      const doctor = DoctorModel.findOne( { email: email } );
      if ( !doctor )
      {
        sendResponse( res, 401, "Doctor is not exist" );
      }
      else
        sendResponse( res, 200, "Doctor is exist" );
    } catch ( err )
    {
      console.log( err );
      sendResponse( res, 500, "Internal Server Error" );
    }
  } else 
  {
    try
    {
      const patient = PatientModel.findOne( { email: result[ 'email' ] } );
      if ( !patient )
      {
        return sendResponse( res, 401, "Patient is not exist" );
      }
      else
        sendResponse( res, 200, "Patient is exist" );
    } catch ( err )
    {
      console.log( err );
      sendResponse( res, 500, "Internal Server Error" );
    }
  }
} );
app.post( '/verify-code_forget', async ( req, res ) =>
{
  const { email, code } = req.body;

  try
  {
    if ( !verificationCodes[ email ] )
    {
      return res.status( 400 ).json( { message: 'Verification code not sent', success: false } );
    }

    if ( verificationCodes[ email ] === code )
    {
      // Remove the used verification code from in-memory storage
      delete verificationCodes[ email ];

      res.json( { message: 'Email verified successfully', success: true } );
    } else
    {
      res.status( 400 ).json( { message: 'Invalid verification code', success: false } );
    }
  } catch ( error )
  {
    console.error( 'Error verifying code:', error );
    res.status( 500 ).json( { message: 'Error verifying code', success: false } );
  }
}
);
app.post( '/change_password', async ( req, res ) =>
{
  console.log( req.body );
  const { email, password } = req.body;

  try
  {
    // Find if the user is a doctor or patient based on email
    const doctor = await DoctorModel.findOne( { email: email } );
    const patient = await PatientModel.findOne( { email: email } );

    if ( doctor )
    {
      const hashedPassword = await bcrypt.hash( password, 10 );
      await DoctorModel.findOneAndUpdate( { email: email }, { password: hashedPassword } );
      return sendResponse( res, 200, 'Password has been updated successfully' );
    } else if ( patient )
    {
      const hashedPassword = await bcrypt.hash( password, 10 );
      await PatientModel.findOneAndUpdate( { email: email }, { password: hashedPassword } );
      return sendResponse( res, 200, 'Password has been updated successfully' );
    } else
    {
      return sendResponse( res, 404, 'User not found', 'User with provided email not found' );
    }
  } catch ( err )
  {
    console.log( err.message );
    return sendResponse( res, 500, err.message, 'Something went wrong' );
  }
} );



server.listen( port, () =>
{
  console.log( `listening on *:${ port }` );
} );


// // / / / 1 - Create a new admin
// const axios = require( "axios" );
// const data = {
//   fullname: 'Eman Elsayed',
//   email: 'emy2192002@gmail.com',
//   password: '0123456789',
//   phone: '01225435099',
//   age: '28',
//   gender: 'male',
// };

// axios.post( 'http://localhost:3000/admin/signup', data )
//   .then( response =>
//   {
//     console.log( response.data );
//   } )
//   .catch( error =>
//   {
//     console.log( error.response );
//   } );
