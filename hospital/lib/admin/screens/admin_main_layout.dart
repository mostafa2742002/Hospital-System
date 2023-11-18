import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hospital/admin/screens/ReadDoctors.dart';
import 'package:hospital/admin/screens/admin_home_screen.dart';
import 'package:hospital/admin/screens/admin_profile.dart';
import 'package:hospital/admin/screens/create_doctor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/Admin.dart';
import '../../models/Appointment.dart';
import '../../models/doctorModel.dart';

class AdminLayuot extends StatefulWidget {
  final Admin admin;
  const AdminLayuot({super.key, required this.admin});

  @override
  State<AdminLayuot> createState() => _AdminLayuotState();
}

class _AdminLayuotState extends State<AdminLayuot> {
  int currentPage = 0;
  List<Doctor> doctors = [];
  final PageController _page = PageController();
  Future<void> get_all_doctors(List<Doctor> doctors, Admin admin) async {
    final Uri api =
        Uri.parse('http://192.168.95.25:3000/admin/readdoctorsdata');
    try {
      final response = await http.get(api);
      final jsonData = json.decode(response.body);
      final doctorList = jsonData['result'];
      List<Doctor> fetchedDoctors = [];
      for (var element in doctorList) {
        final doctortId = element['_id'].toString();
        final appointments = await _getappointmentsfordoctor(doctortId);
        final doctor = Doctor(
          id: element['_id'] ?? 'not found',
          fullname: element['fullname'] ?? 'not found',
          email: element['email'] ?? 'not found',
          password: element['password'] ?? 'not found',
          Specialization: element['Specialization'] ?? 'not found',
          gender: element['gender'] ?? 'not found',
          phone: element['phone'] ?? 'not found',
          address: element['address'] ?? 'not found',
          aboutDoctor: element['aboutDoctor'] ?? 'not found',
          price: element['Price'] ?? 'not found',
          photo: element['photo'] ?? '',
          age: element['age'] ?? 'not found',
          appointments: _convertToAppointments(appointments) ?? [],
          token: '',
        );
        fetchedDoctors.add(doctor);
      }

      doctors.addAll(fetchedDoctors);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    get_all_doctors(doctors, widget.admin);
  }

  @override
  Widget build(BuildContext context) {
    print(doctors);
    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value) {
          setState(() {
            currentPage = value;
          });
        }),
        children: <Widget>[
          AdminScreen(admin: widget.admin),
          CreateDoctor(admin: widget.admin, doctors: doctors),
          ReadDoctors(doctors: doctors, admin: widget.admin),
          ProfilePage(admin: widget.admin),
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
              icon: Icon(
                CupertinoIcons.add,
              ),
              label: "Create",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userDoctor),
              label: 'Doctors',
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

Future<List<dynamic>> _getappointmentsfordoctor(String id) async {
  final Uri api =
      Uri.parse('http://192.168.95.25:3000/doctor/getallappointments');
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
