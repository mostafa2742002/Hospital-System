const mongoose = require('mongoose');

const AdminSchema = new mongoose.Schema({
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
        trim: true,
        match: /^(010|011|012|015)[0-9]{8}$/
    },
    photo: {
        type: String,
    },
    age: {
        type: String,
        required: [true, "Age is Required"],
    },
    gender: {
        type: String,
        required: [true, "gender is Required"],
    },
}, { timestamps: true });

const Admin = mongoose.model('Admin', AdminSchema);
module.exports = Admin;

