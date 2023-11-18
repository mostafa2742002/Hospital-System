import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hospital/doctors/create_available_time.dart';
import 'package:hospital/doctors/doctorscreen.dart';
import 'package:hospital/models/patient.dart';
import 'package:hospital/models/doctorModel.dart';
import 'package:hospital/doctors/appointment_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Appointment.dart';
import '../models/upCommingAppointments.dart';
import 'doctor_profile.dart';

class DoctorLayout extends StatefulWidget {
  final Doctor doctor;
  const DoctorLayout({super.key, required this.doctor});

  @override
  State<DoctorLayout> createState() => _DoctorLayoutState();
}

class _DoctorLayoutState extends State<DoctorLayout> {
  int currentPage = 0, cnt = 0;
  List<upCommingAppointment> appointments = [];
  final PageController _page = PageController();
  @override
  Widget build(BuildContext context) {
    if (cnt == 0) {
      get_all_patient(appointments, widget.doctor);
      cnt++;
    }
    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value) {
          setState(() {
            currentPage = value;
          });
        }),
        children: <Widget>[
          DoctorScreen(doctor: widget.doctor, appointments: appointments),
          CreateAvailableTime(doctor: widget.doctor),
          AppointmentPage(doctor: widget.doctor),
          ProfilePage(doctor: widget.doctor),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0XFF0080FE),
          unselectedItemColor: Colors.black26,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          currentIndex: currentPage,
          onTap: (page) {
            setState(() {
              currentPage = page;
              _page.animateToPage(
                page,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.houseChimneyMedical),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.add),
              label: 'create',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidCalendarCheck),
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidUser),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// // 64cf7fa068475d52482b9e89
Future<void> get_all_patient(
    List<upCommingAppointment> appointmentss, Doctor doctor) async {
  final Uri api =
      Uri.parse('http:// 192.168.43.45:3000/doctor/getpatientandappointments');
  try {
    final response = await http.post(api, body: {
      'id': doctor.id,
    });
    final jsonData = json.decode(response.body);
    // print(jsonData);
    List<Patient> patients_array = [];
    List<Appointment> appointments_array = [];
    for (var ele in jsonData['result']['patients']) {
      // Extract appointment details
      final appointments = await _getappointments(ele['_id']);

      final patient = new Patient(
        email: ele['email'] ?? 'not found',
        password: ele['password'] ?? 'not found',
        fullname: ele['fullname'] ?? 'not found',
        age: ele['age'] ?? 'not found',
        photo: ele['photo'] ?? 'not found',
        gender: ele['gender'] ?? 'not found',
        phone: ele['phone'] ?? 'not found',
        id: ele['_id'] ?? 'not found',
        token: ele['token'] ?? 'not found',
        appointments: _convertToAppointments(appointments) ?? [],
      );
      patients_array.add(patient);
    }
    for (var ele in jsonData['result']['appointments']) {
      final appointment = new Appointment(
        date: ele['date'],
        time: ele['time'],
        status: ele['status'],
        patientId: ele['patientId'],
        doctorId: ele['doctorId'],
        Id: ele['_id'],
      );
      appointments_array.add(appointment);
    }

    for (int i = 0; i < patients_array.length; i++) {
      upCommingAppointment appoint = upCommingAppointment(
        patient: patients_array[i],
        appointment: appointments_array[i],
      );
      appointmentss.add(appoint);
    }
  } catch (e) {
    print(e);
  }
}

Future<List<dynamic>> _getappointments(String id) async {
  final Uri api = Uri.parse('http://192.168.1.7:3000/patient/getappointments');
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
    String patientId = appointmentData['patientId'] ?? '';
    String doctorId = appointmentData['doctorId'] ?? '';
    String Id = appointmentData['_id'] ?? '';

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
