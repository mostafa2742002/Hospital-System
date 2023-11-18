const bcrypt = require( "bcryptjs" );
const jwt = require( "jsonwebtoken" );
const Admin = require( "../../models/Admin" );
const key = "mostafa_eman_eman_menna_hasnaa";
const sendResponse = require( "../../utils/sendResonse" );
const checkFile = require( "../../validator/Admin/EditProfile" );

// edit the profile {name , email , password}
const Edit = async ( req, res ) =>
{
  try
  {
    const error = await checkFile( req.body );
    if ( error[ 0 ] !== "valid" )
    {
      return sendResponse( res, error[ 1 ], error[ 0 ] );
    }
    let founded = await Admin.findOne( { email: req.body.email } );
    //  update the all data
    if ( founded )
    {
      founded.fullname = data.fullname;
      founded.email = data.email;
      founded.password = data.password;
      founded.photo = data.photo;
      await founded.save();
      return sendResponse( res, 200, "Profile has been updated successfully" );
    } else
    {
      return sendResponse( res, 404, "Admin not found" );
    }
  } catch ( err )
  {
    console.log( err );
    return sendResponse( res, 500, "Internal Server Error" );
  }
};

module.exports = { Edit };
