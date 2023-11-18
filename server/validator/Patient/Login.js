const Joi = require("joi");
const Patient = require("../../models/Patient");
const bcrypt = require("bcryptjs");

const Login_Validator = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
});

test = async function (data) {
  const { error } = Login_Validator.validate(data);

  // check if the email is exist
  let founded = await Patient.findOne({ email: data.email });
  if (!founded) {
    return ["Email is not exist", 401];
  }

  // check if the password is correct
  const passwordMatch = await bcrypt.compare(data.password, founded.password);
  if (!passwordMatch) {
    return ["Password is wrong", 401];
  }

  if (error) {
    return [error.details[0].message, 400];
  } else {
    return ["valid", 200];
  }
};

module.exports = test;
