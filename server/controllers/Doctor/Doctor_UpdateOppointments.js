const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Doctor = require("../../models/Admin");
const key = "mostafa_eman_eman_menna_hasnaa";
const sendResponse = require("../../utils/sendResonse");

const UpdateOppointments = async (req, res) => {
  try {
    const doctor = Doctor.findOne({ email: req.body.email });
    if (!doctor) {
      return sendResponse(res, 401, "Doctor is not exist");
    }
    doctor.appointments = req.body.appointments;
    await doctor.save();
  } catch (err) {
    console.log(err);
    return sendResponse(res, 500, "Internal Server Error");
  }
};

module.exports = { UpdateOppointments };
