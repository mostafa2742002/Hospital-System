const Joi = require( "joi" );

const DeleteAdminValidator = Joi.object( {
    email: Joi.string().email().required(),
} );

test = async ( req, res ) =>
{
    try
    {
        const validationResult = DeleteAdminValidator.validate( req.body );

        if ( validationResult.error )
        {
            return sendResponse( res, 400, validationResult.error.details[ 0 ].message );
        }

        await AdminDeleteProfileController.deleteAdminProfile( req, res );
    } catch ( err )
    {
        console.error( err );
        return sendResponse( res, 500, "Internal Server Error" );
    }
};

module.exports = { test };
