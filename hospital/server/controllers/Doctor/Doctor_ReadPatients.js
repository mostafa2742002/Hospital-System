const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Patient = require("../../models/Patient");
const Doctor = require("../../models/Doctor");
const Appointment = require("../../models/appointment");
const key = "mostafa_eman_eman_menna_hasnaa";
const sendResponse = require("../../utils/sendResonse");


const ReadPatients = async (req, res) => {
  try {
    
    const doctor = await Doctor.findOne({ email: req.body.email });
    if (!doctor) {
      return sendResponse(res, 404, "Doctor not found");
    }
    const data = [];
    for (let i = 0; i < doctor.appointments.length; i++) {
      const appointment = await Appointment.findById(doctor.appointments[i]);
      if(appointment.status == "booked"){
        const patient = await Patient.findById(appointment.patientId);
        data.push(patient);
      }
    }
    console.log(data);
    return sendResponse(res, 200, "Patients", data);    
  } catch (err) {
    console.log(err);
    return sendResponse(res, 500, "Internal Server Error");
  }
};

module.exports = { ReadPatients };