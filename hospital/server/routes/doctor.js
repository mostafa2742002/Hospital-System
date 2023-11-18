const express = require("express");
const router = express.Router();

const DoctorLogin = require("../controllers/Doctor/Doctor_Login");
const DoctorCreateOppointments = require("../controllers/Doctor/Doctor_CreateOppointments");
const DoctorReadPatients = require("../controllers/Doctor/Doctor_ReadPatients");
const DoctorUpdateOppointment = require("../controllers/Doctor/Doctor_UpdateOppointments");
const DoctorGetAppointments = require("../controllers/Doctor/Doctor_GetAppointments");
const DoctorGetPatientAndAppointments = require("../controllers/Doctor/Doctor_GetPatientAndAppointments");
// const DoctorShatWithPatient = require("../controllers/Doctor/Doctor_ShatWithPatient");

// const { CheckDoctor } = require("../middleware/CheckDoctor");
// const { CheckAuth } = require("../middleware/CheckAuth");

router.post("/login", DoctorLogin.Login);
router.post("/createoppointment", DoctorCreateOppointments.CreateOppointments);
router.post("/readpatients", DoctorReadPatients.ReadPatients);
router.post("/updateoppointment", DoctorUpdateOppointment.UpdateOppointments);
router.post("/getallappointments", DoctorGetAppointments.GetAppointments);
router.post("/getpatientandappointments", DoctorGetPatientAndAppointments.GetPatientAndAppointments);
// router.get("/shatwithpatient", DoctorShatWithPatient.DoctorShatWithPatient);

module.exports = router;
