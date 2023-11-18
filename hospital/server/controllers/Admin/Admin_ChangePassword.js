const bcrypt = require("bcryptjs");
const Admin = require("../../models/Admin");
const sendResponse = require("../../utils/sendResonse");
const checkFile = require("../../validator/Admin/ChangePassword");

const ChangePass = async (req, res) => {
  try {
    // validate the data
    const error = await checkFile(req.body);
    if (error[0] !== "valid") {
      // we will receive a list of the message and the status code
      return sendResponse(res, error[1], error[0]);
    }

    // update the password
    const admin = await Admin.findById({ _id: req.admin._id });
    password = await bcrypt.hash(newpassword, 10);
    await Admin.findByIdAndUpdate(
      { _id: admin._id },
      { password: password },
      { new: true }
    );

    // send the response
    return sendResponse(res, 200, "Password has been updated successfully");
  } catch (err) {
    console.log(err.message);
    return sendResponse(res, 500, err.message, "Something went wrong");
  }
};

module.exports = { ChangePass };
