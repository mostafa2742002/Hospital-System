const express = require( "express" );
const router = express.Router();

const PatientLogin = require( "../controllers/Patient/Patient_Login" );
const PatientSignUp = require( "../controllers/Patient/Patient_SignUp" );
const PopularDoctors = require( "../controllers/Patient/Popular_Doctors" );
const PatientGetAppointments = require( "../controllers/Patient/Patient_GetAppointments" );
const PatientBookAppointment = require( "../controllers/Patient/Patient_BookAppointment" );
const PatientUpdateProfile = require( "../controllers/Patient/PatientUpdate" );
const PatientDeleteProfile = require( "../controllers/Patient/DeletePatient" );

router.post( "/signup", PatientSignUp.SignUp );
router.post( "/login", PatientLogin.Login );
router.get( "/populardoctor", PopularDoctors.PopularDoctors );
router.post( "/getappointments", PatientGetAppointments.GetAppointments );
router.post( "/bookappointment", PatientBookAppointment.BookAppointment );
router.post( "/updatepatient", PatientUpdateProfile.UpdatePatient );
router.post( "/deletepatient", PatientDeleteProfile.DeletePatient );

module.exports = router;