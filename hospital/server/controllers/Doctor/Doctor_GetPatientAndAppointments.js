const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Appointment = require("../../models/appointment");
const Patient = require("../../models/Patient");
const key = "mostafa_eman_eman_menna_hasnaa";
const sendResponse = require("../../utils/sendResonse");

const GetPatientAndAppointments = async (req, res) => {
  try {
    const { id } = req.body;
    // console.log(id);
    const patients = [];
    const appointments = [];
    const appoint = await Appointment.find({ doctorId: id });
    for (let i = 0; i < appoint.length; i++) {
      if(appoint[i].status === "booked"){

        const patient = await Patient.findById(appoint[i].patientId);
        patients.push(patient);
        appointments.push(appoint[i]);
      }
    }
    result = {appointments : appointments, patients : patients};
    
    return sendResponse(res, 200, "Appointments", result);
  } catch (err) {
    console.log(err);
    return sendResponse(res, 500, "Internal Server Error");
  }
};

module.exports = { GetPatientAndAppointments };
