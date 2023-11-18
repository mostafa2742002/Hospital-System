const mongoose = require("mongoose");

const AppointmentSchema = new mongoose.Schema(
  {
    date: { type: String, trim: true },
    time: { type: String, trim: true },
    status: { type: String, trim: true },
    Id: { type: String, trim: true },
    doctorId: { type: String, trim: true },
    patientId: { type: String, trim: true },
  },
  { timestamps: true }
);

const Appointment = mongoose.model("Appointment", AppointmentSchema);
module.exports = Appointment;
