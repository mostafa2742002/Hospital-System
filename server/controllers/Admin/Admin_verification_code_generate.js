
const express = require( "express" );
const app = express();
const verificationCodes = {};

const http = require( "http" );
const nodemailer = require( 'nodemailer' );

const transporter = nodemailer.createTransport( {
    service: 'gmail',
    auth: {
        user: 'backendddteam2023@gmail.com',
        pass: 'tnxewrwhycmahmhf',
    },
} );
function generateVerificationCode ()
{

    const length = 6;
    const characters = '0123456789';

    let code = '';
    for ( let i = 0; i < length; i++ )
    {
        const randomIndex = Math.floor( Math.random() * characters.length );
        code += characters[ randomIndex ];
    }

    return code;
}
const verificationEmail = async ( req, res ) =>
{
    const { email } = req.body;

    const verificationCode = generateVerificationCode();
    console.log( verificationCode );
    verificationCodes[ email ] = verificationCode; // Store the code in-memory
    console.log( email );
    const mailOptions = {
        from: 'BackendTeam',
        to: email,
        subject: 'Email Verification Code',
        text: `Your verification code is: ${ verificationCode }`,
    };

    try
    {
        await transporter.sendMail( mailOptions );
        res.status( 200 ).json( { message: 'Verification email sent' } );
    } catch ( error )
    {
        console.error( 'Error sending verification email:', error );
        res.status( 500 ).json( { message: 'Error sending verification email' } );
    }
}

const verifyCode = async ( req, res ) =>
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
module.exports = { verificationEmail, verifyCode };

