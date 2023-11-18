const jwt = require("jsonwebtoken");
const sendResponse = require("../utils/sendResonse");

const key = "mostafa_eman_eman_menna_hasnaa";
module.exports = (req, res, next) => {
  try {
    const token = req.body.token;
    const decoded = jwt.verify(token, key); 
    req.body.auth = decoded._id;
    next();
  } catch (err) {
    return sendResponse(res, 401, "Authentication failed");
  }
};