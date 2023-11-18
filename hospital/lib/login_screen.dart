import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital/components/social_button.dart';
import 'package:hospital/forgetScreen.dart';
import 'package:hospital/patients/components/main_layout.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/signup_screen.dart';

import 'admin/screens/admin_main_layout.dart';
import 'doctors/doctor_main_layout.dart';
import 'models/Admin.dart';
import 'models/Appointment.dart';
import 'models/patient.dart';
import 'models/doctorModel.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool passToggle = true;
  final email = TextEditingController();
  final password = TextEditingController();
  var response;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.06),
                child: Image.asset(
                  "assets/doctors.png",
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter email",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.03,
                ),
                child: TextField(
                  controller: password,
                  obscureText: passToggle ? true : false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Enter Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: passToggle
                          ? const Icon(CupertinoIcons.eye_slash_fill)
                          : const Icon(CupertinoIcons.eye_fill),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                child: InkWell(
                  onTap: () {
                    // receive the response from the _loginUser function
                    _loginUSer(email.text, password.text, context);
                    _loginUSer2(email.text, password.text, context);
                    // make a map for the user data
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0XFF0080FE),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF0080FE),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> _loginUSer(
    String email, String password, BuildContext context) async {
  final Uri api = Uri.parse('http://192.168.43.45:3000/doctor/login');
  try {
    final response = await http.post(api, body: {
      'email': email,
      'password': password,
    });
    print(response.body);

    final jsonData = json.decode(response.body);
    final result = jsonData['result'];
    if (result['doctor'] != null) {
      _loginAsDoctor(context, result);
    }
  } catch (e) {
    print(e);
  }
}

Future<dynamic> _loginUSer2(
    String email, String password, BuildContext context) async {
  final Uri api = Uri.parse('http://192.168.43.45:3000/patient/login');
  try {
    final response = await http.post(api, body: {
      'email': email,
      'password': password,
    });
    print(response.body);
    final jsonData = json.decode(response.body);
    final result = jsonData['result'];
    if (result['patient'] != null) {
      _loginAsPatient(context, result);
    }
  } catch (e) {
    print(e);
  }
}

void _loginAsAdmin(BuildContext context, dynamic result) {
  final admin = Admin(
    fullname: result['admin']['fullname'] ?? 'not found',
    email: result['admin']['email'] ?? 'not found',
    password: result['admin']['password'] ?? 'not found',
    phone: result['admin']['phone'] ?? 'not found',
    id: result['admin']['_id'] ?? 'not found',
    gender: result['admin']['gender'] ?? 'not found',
    age: result['admin']['age'] ?? 'not found',
    token: result['token'] ?? 'not found',
    photo: result['admin']['photo'] ?? 'not found',
  );
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AdminLayuot(
                admin: admin,
              )));
}

void _loginAsDoctor(BuildContext context, dynamic result) async {
  final doctorId = result['doctor']['_id'].toString();
  final appointments = await _getappointmentsfordoctor(doctorId);

  final doctor = Doctor(
    fullname: result['doctor']['fullname'] ?? 'not found',
    Specialization: result['doctor']['Specialization'] ?? 'not found',
    phone: result['doctor']['phone'] ?? 'not found',
    password: result['doctor']['password'] ?? 'not found',
    email: result['doctor']['email'] ?? 'not found',
    gender: result['doctor']['gender'] ?? 'not found',
    photo: result['doctor']['photo'] ?? 'not found',
    id: doctorId,
    address: result['doctor']['address'] ?? 'not found',
    aboutDoctor: result['doctor']['aboutDoctor'] ?? 'not found',
    price: result['doctor']['price'] ?? 'not found',
    age: result['doctor']['age'] ?? 'not found',
    appointments: _convertToAppointments(appointments),
    token: result['token'] ?? 'not found',
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DoctorLayout(
        doctor: doctor,
      ),
    ),
  );
}

void _loginAsPatient(BuildContext context, dynamic result) async {
  final patientId = result['patient']['_id'].toString();
  final appointments = await _getappointmentsforpatient(patientId);

  final patient = Patient(
    email: result['patient']['email'] ?? 'not found',
    password: result['patient']['password'] ?? 'not found',
    fullname: result['patient']['fullname'] ?? 'not found',
    age: result['patient']['age'] ?? 'not found',
    photo: result['patient']['photo'] ?? 'null',
    gender: result['patient']['gender'] ?? 'not found',
    phone: result['patient']['phone'] ?? 'not found',
    id: result['patient']['_id'] ?? 'not found',
    appointments: _convertToAppointments(appointments) ?? [],
    token: result['patient']['token'] ?? 'not found',
  );
  List<Doctor> myDoctors = [];
  for (var doc in result['doctors']) {
    final doctortId = doc['_id'].toString();
    final appointments = await _getappointmentsfordoctor(doctortId);
    final doctor = Doctor(
      fullname: doc['fullname'] ?? 'not found',
      Specialization: doc['Specialization'] ?? 'not found',
      phone: doc['phone'] ?? 'not found',
      password: doc['password'] ?? 'not found',
      email: doc['email'] ?? 'not found',
      gender: doc['gender'] ?? 'not found',
      photo: doc['photo'] ?? 'not found',
      id: doc['_id'] ?? 'not found',
      address: doc['address'] ?? 'not found',
      aboutDoctor: doc['aboutDoctor'] ?? 'not found',
      price: doc['price'] ?? 'not found',
      age: doc['age'] ?? 'not found',
      appointments: _convertToAppointments(appointments) ?? [],
      token: doc['token'] ?? 'not found',
    );

    myDoctors.add(doctor);
  }
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MainLayout(
                patient: patient,
                myDoctors: myDoctors,
              )));
}

Future<List<dynamic>> _getappointmentsfordoctor(String id) async {
  final Uri api =
      Uri.parse('http://192.168.43.45:3000/doctor/getallappointments');
  try {
    final response = await http.post(api, body: {
      'id': id,
    });
    final jsonData = json.decode(response.body);

    return jsonData['result'];
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List<dynamic>> _getappointmentsforpatient(String id) async {
  final Uri api =
      Uri.parse('http://192.168.43.45:3000/patient/getappointments');
  try {
    final response = await http.post(api, body: {
      'id': id,
    });
    final jsonData = json.decode(response.body);

    return jsonData['result'];
  } catch (e) {
    print(e);
    return [];
  }
}

List<Appointment> _convertToAppointments(List<dynamic> appointmentsData) {
  List<Appointment> appointments = [];

  for (dynamic appointmentData in appointmentsData) {
    String date = appointmentData['date'] ?? '';
    String time = appointmentData['time'] ?? '';
    String status = appointmentData['status'] ?? '';
    String Id = appointmentData['_id'] ?? '';
    String patientId = appointmentData['patientId'] ?? '';
    String doctorId = appointmentData['doctorId'] ?? '';

    Appointment appointment = Appointment(
      date: date,
      time: time,
      status: status,
      patientId: patientId,
      doctorId: doctorId,
      Id: Id,
    );

    appointments.add(appointment);
  }

  return appointments;
}
