# Hospital Management System

This project is a Hospital Management System built with **Node.js**, **Express.js**, **MongoDB**, and **Socket.io**. It provides a comprehensive solution for hospital administration, allowing administrators, doctors, and patients to perform various tasks efficiently.

## Features

### Admin Operations

1. **Signup and Login:**
   - Admins can sign up and log in to the system.
   - Email verification is required before any operations can be performed.

2. **Profile Management:**
   - Admins can upload a profile photo.
   - Edit profile details, including changing passwords.
   - Email address changes trigger a verification code sent to the new email.

3. **Doctor Management:**
   - CRUD operations for managing doctor data.

### Doctor Operations

1. **Login:**
   - Doctors can log in to the system.

2. **Appointment Management:**
   - Doctors can create available appointments for patients.

### Patient Operations

1. **Signup and Login:**
   - Patients can sign up and log in to the system.

2. **Appointment Booking:**
   - Patients can choose available appointment times with their preferred doctors.

## Project Structure

The project follows a modular structure, with separate routes and models for patients, doctors, and administrators. The main server file is `server.js`.

### Technologies Used

- **Node.js:** A JavaScript runtime for building server-side applications.
- **Express.js:** A web application framework for Node.js.
- **MongoDB:** A NoSQL database used for data storage.
###Additional Notes
    -Email functionality is implemented using Nodemailer for admin and user verification.
    -Passwords are securely hashed using bcrypt.
