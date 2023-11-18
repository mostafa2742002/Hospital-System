const sendResponse = require("../utils/sendResonse");
const Admin = require("../models/Admin");

module.exports = async (req, res, next) => {
  try {
    const adminId = req.body.auth;
    const user = await Admin.findById(adminId);
    if (!user) {
      return sendResponse(res, 404, "The user is not found");
    }
    next();
  } catch (err) {
    console.log(err);
    return sendResponse(res, 500, "Something went wrong");
  }
};