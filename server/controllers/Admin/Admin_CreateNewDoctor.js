const Doctor = require("../../models/Doctor");
const sendResponse = require("../../utils/sendResonse");
const bcrypt = require("bcryptjs");


const CreateNewDoctor = async (req, res) => {
  try {

    req.body.password = await bcrypt.hash(req.body.password, 10);
    const doctor = new Doctor(
      {
        fullname : req.body.fullname,
        email : req.body.email,
        password : req.body.password,
        gender : req.body.gender,
        Specialization : req.body.Specialization,
        phone : req.body.phone,
        photo : req.body.photo,
        aboutDoctor : req.body.aboutDoctor,
        address : req.body.address,
        price : req.body.price,
        age : req.body.age,
      }
    );
    await doctor.save();
    return sendResponse(res, 200, "Doctor has been created successfully", doctor);
  } catch (err) {
    console.log(err);
    return sendResponse(res, 500, "Internal Server Error");
  }
};

module.exports = { CreateNewDoctor };

