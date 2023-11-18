const Joi = require("joi");
const Admin = require("../../models/Admin");
const bcrypt = require("bcryptjs");

const Edit_Validator = Joi.object({
  oldpassword: Joi.string().min(6).required(),
  newpassword: Joi.string().min(6).required(),
  confirmpassword: Joi.string().min(6).required(),

});

test = async function (data) {
  const { error } = Edit_Validator.validate(data);

  const admin = await Admin.findById({ _id: req.body.id });
  const result = bcrypt.compare(oldpassword, admin.password);
  if (!result) return ["The old password is wrong", 400];
  if (newpassword !== confirmpassword)
    return ["The two passwords are not identical", 400];

  if (error) {
    return [error.details[0].message, 400];
  } else {
    return ["valid", 200];
  }
};

module.exports = test;
