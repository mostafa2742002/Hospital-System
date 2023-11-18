const express = require("express");
const router = express.Router();

const PatientLogin = require("../controllers/Patient/Patient_Login");
const PatientSignUp = require("../controllers/Patient/Patient_SignUp");
const PopularDoctors = require("../controllers/Patient/Popular_Doctors");
const PatientGetAppointments = require("../controllers/Patient/Patient_GetAppointments");
const PatientBookAppointment = require("../controllers/Patient/Patient_BookAppointment");
router.post("/signup", PatientSignUp.SignUp);
router.post("/login", PatientLogin.Login);
router.get("/populardoctor", PopularDoctors.PopularDoctors);
router.post("/getappointments", PatientGetAppointments.GetAppointments);
router.post("/bookappointment", PatientBookAppointment.BookAppointment);

module.exports = router;
