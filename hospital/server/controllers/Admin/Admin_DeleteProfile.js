const Admin = require( "../../models/Admin" );
const sendResponse = require( "../../utils/sendResonse" ); // Adjust the path if needed

const deleteAdminProfile = async ( req, res ) =>
{
    try
    {
        const emailToDelete = req.body.email; // Extract the email from request body
        const deletedAdmin = await Admin.findOneAndDelete( { email: emailToDelete } );

        if ( deletedAdmin )
        {
            return sendResponse( res, 200, "Admin profile deleted successfully" );
        } else
        {
            return sendResponse( res, 404, "Admin not found" );
        }
    } catch ( err )
    {
        console.error( err );
        return sendResponse( res, 500, "Internal Server Error" );
    }
};

module.exports = { deleteAdminProfile };
