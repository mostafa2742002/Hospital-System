const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Appointment = require("../../models/appointment");
const Patient = require("../../models/Patient");
const Doctor = require("../../models/Doctor");
const key = "mostafa_eman_eman_menna_hasnaa";
const sendResponse = require("../../utils/sendResonse");


const BookAppointment = async (req, res) => {
    try{
        const {doctorid , patientid, appointmentid} = req.body;
        const appointment = await Appointment.findById(appointmentid);
        appointment.patientId = patientid;
        appointment.status = "booked";
        await appointment.save();
        const patient = await Patient.findById(patientid);
        patient.appointments.push(appointment._id);
        await patient.save();

        return sendResponse(res, 200, "Appointment Booked Successfully");
    }
    catch(err){
        console.log(err);
        return sendResponse(res, 500, "Internal Server Error");
    }
};


module.exports = { BookAppointment };