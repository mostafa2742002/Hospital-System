const mongoose = require('mongoose');
const Appointment = require('./appointment');
const PatientSchema = new mongoose.Schema({
    fullname: {
        type: String,
        required: [true, "Fullname is Mandatory"],
        minlength: 6,
        trim: true
    },
    email: {
        type: String,
        required: [true, "Email is Mandatory"],
        unique: true,
        trim: true,
        match: /^\w+([-+.]\w+)*@((yahoo|gmail|outlook)\.com)$/
    },
    password: {
        type: String,
        required: [true, "Password is Required"],
        minlength: 6,
        trim: true
    },
    phone: {
        type: String,
        required: [true, "Phone is Required"],
        minlength: 10,
        trim: true
    },
    photo: {
        type: String,
    },
    gender: {
        type: String,
    },  
    age: {  
        type: String,
    },
    appointments: {
       
        type: [String],
        default: []
        
    },

}, { timestamps: true });

const Patient = mongoose.model('Patient', PatientSchema);
module.exports = Patient;
