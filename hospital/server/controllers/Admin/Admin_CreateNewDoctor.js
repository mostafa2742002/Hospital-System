const Doctor = require("../../models/Doctor");
const sendResponse = require("../../utils/sendResonse");
const bcrypt = require("bcryptjs");


const CreateNewDoctor = async (req, res) => {
  try {

    req.body.password = await bcrypt.hash(req.body.password, 10);
    const doctor = new Doctor(req.body);
    await doctor.save();
    return sendResponse(res, 200, "Doctor has been created successfully", doctor);
  } catch (err) {
    console.log(err);
    return sendResponse(res, 500, "Internal Server Error");
  }
};

module.exports = { CreateNewDoctor };

