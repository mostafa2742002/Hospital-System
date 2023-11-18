const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Patient = require("../../models/Patient");
const key = "mostafa_eman_eman_menna_hasnaa";
const sendResponse = require("../../utils/sendResonse");
const checkFile = require("../../validator/Patient/SignUp");

const SignUp = async (req, res) => {
  try {
    // validate the data
    const error = await checkFile(req.body);
    if (error[0] !== "valid") {
      return sendResponse(res, error[1], error[0]);
    }

    // circrpt the password
    req.body.password = await bcrypt.hash(req.body.password, 10);

    // save the data
    const patient = await new Patient(req.body).save();

    // generate token
    const token = jwt.sign({ _id: patient._id }, key);
    const result = { token: token, patient: patient };

    // send the response
    return sendResponse(
      res,
      201,
      "Account has been created Successfully",
      result
    );
  } catch (err) {
    console.log(err);
    return sendResponse(res, 500, "Internal Server Error");
  }
};

module.exports = { SignUp };
