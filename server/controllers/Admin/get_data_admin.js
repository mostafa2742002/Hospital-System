const Admin = require( "../../models/Admin" );
const sendResponse = require( "../../utils/sendResonse" );
const getAdminDataByEmail = async ( req, res ) =>
{
    try
    {
        const { email } = req.body;

        if ( !email )
        {
            return sendResponse( res, 400, "Email is required" );
        }

        const admin = await Admin.findOne( { email } );

        if ( !admin )
        {
            return sendResponse( res, 404, "Admin not found" );
        }

        return sendResponse( res, 200, "Admin data retrieved", admin.toObject() );
    } catch ( err )
    {
        console.log( err );
        return sendResponse( res, 500, "Internal Server Error" );
    }
};

module.exports = { getAdminDataByEmail };
