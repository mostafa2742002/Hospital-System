const bcrypt = require("bcryptjs");
const Admin = require("../../models/Admin");
const sendResponse = require("../../utils/sendResonse");


const ChangePass = async (req, res) => {
  try {

    // update the password
    const admin = await Admin.findById({ _id: req.body.id });
    passwordd = await bcrypt.hash(req.body.newpassword, 10);
    await Admin.findByIdAndUpdate(
      { _id: admin._id },
      { password: passwordd },
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
