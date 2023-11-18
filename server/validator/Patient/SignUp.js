const Joi = require("joi");
const Patient = require("../../models/Patient");

const SignUp_Validator = Joi.object({
  fullname: Joi.string().min(6).required(),
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
  phone: Joi.string().min(10).required(),
});

test = async function (data) {
  const { error } = SignUp_Validator.validate(data);
  let f = await Patient.findOne({ email: data.email });

  if (error || f) {
    if (f) {
      // return the error message if email is already exist and the status code
      return ["Email is already exist", 401];
    }
    return [error.details[0].message, 401];
  } else {
    return ["valid", 200];
  }
};

module.exports = test;
