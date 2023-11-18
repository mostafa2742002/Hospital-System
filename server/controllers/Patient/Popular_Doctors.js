const sendResponse = require("../../utils/sendResonse");
const Doctor = require("../../models/Doctor");

const PopularDoctors = async (req, res) => {
    try{
        const doctors = await Doctor.find().limit(4);
        return sendResponse(res, 200, "Popular Doctors", doctors);
    }
    catch(err){
        console.log(err);
        return sendResponse(res, 500, "Internal Server Error");
    }
}


module.exports = { PopularDoctors };
