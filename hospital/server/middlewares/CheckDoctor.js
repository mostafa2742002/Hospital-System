const sendResponse = require("../utils/sendResponse");
const Doctor = require("../models/Doctor").default;
module.exports = async (req, res, next) => {
  try {
    const doctor = await Doctor.findById({ _id: req.user._id });
    if (!doctor) {
      return sendResponse(res, 404, "The doctor is not found");
    }
    next();
  } catch (err) {
    return sendResponse(res, 500, "Something went wrong");
  }
};


