const Admin = require("../../models/Admin");
const key = "mostafa_eman_eman_menna_hasnaa";
const sendResponse = require("../../utils/sendResonse");

const Upload = async (req, res) => {
  try {
    // check if the file is exist
    console.log(req.body.photo);
    if (!req.body.photo) {
      return sendResponse(res, 400, "Photo is required");
    }

    // get the admin
    const admin = await Admin.findById(req.admin._id);

    // update the photo
    admin.photo = req.body.photo;
    await admin.save();

    // send the response
    return sendResponse(res, 200, "Photo uploaded successfully", admin);
  } catch (err) {
    console.log(err);
    return sendResponse(res, 500, "Internal Server Error");
  }
};

module.exports = { Upload };
