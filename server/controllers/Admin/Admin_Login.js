const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Admin = require("../../models/Admin");
const key = "mostafa_eman_eman_menna_hasnaa";
const sendResponse = require("../../utils/sendResonse");
const checkFile = require("../../validator/Admin/Login");

const Login = async (req, res) => {
  try {
    // validate the data
    const error = await checkFile(req.body);
    if (error[0] !== "valid") {
      return sendResponse(res, error[1], error[0]);
    }
    // 401 status code means unauthorized
    // generate token
    var admin = await Admin.findOne({ email: req.body.email });
    const token = jwt.sign({ _id: admin._id }, key);
    const result = { token: token, admin: admin };

    // send the response
    return sendResponse(res, 200, "Login as admin", result);
  } catch (err) {
    console.log(err);
    return sendResponse(res, 500, "Internal Server Error");
  }
};

module.exports = { Login };
