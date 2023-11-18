const express = require( "express" );
const app = express();
const verificationCodes = {};

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
