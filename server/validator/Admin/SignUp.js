const Joi = require("joi");
const Admin = require("../../models/Admin");

const SignUp_Validator = Joi.object({
  fullname: Joi.string().min(6).required(),
  email: Joi.string().email().required(),
  phone : Joi.string().pattern(/^(010|011|012|015)[0-9]{8}$/).required(),
  password: Joi.string().min(6).required(),
  age : Joi.string().required(),
  gender : Joi.string().required(),
});

test = async function (data) {
  const { error } = SignUp_Validator.validate(data);
  let f = await Admin.findOne({ email: data.email });

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
