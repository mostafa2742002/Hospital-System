const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Doctor = require("../../models/Doctor");
const appointmentt = require("../../models/appointment");
const key = "mostafa_eman_eman_menna_hasnaa";
const sendResponse = require("../../utils/sendResonse");
const CreateOppointments = async (req, res) => {
  try {
    const { email, appointment } = req.body;
    const doctor = await Doctor.findOne({ email });

    if (!doctor) {
      return sendResponse(res, 404, "Doctor not found");
    }
    temp = JSON.parse(appointment);
    const newAppointment = new appointmentt({
      date: temp.date,
      time: temp.time,
      status: temp.status,
      doctorId: temp.doctorId,
      patientId: temp.patientId,
    });
    await newAppointment.save();
    doctor.appointments.push(newAppointment._id);
    await doctor.save();

    return sendResponse(res, 200, "Appointment created successfully");
  } catch (err) {
    console.log(err);
    return sendResponse(res, 500, "Internal Server Error");
  }
};
module.exports = { CreateOppointments };
