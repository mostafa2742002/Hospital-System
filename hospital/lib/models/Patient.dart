// Purpose: Patient model

import 'Appointment.dart';

class Patient {
  final String email;
  final String password;
  final String fullname;
  final String age;
  final String phone;
  final String photo;
  final String gender;
  final String id;
  final List<Appointment> appointments;
  final String token;

  Patient({
    required this.email,
    required this.password,
    required this.fullname,
    required this.age,
    required this.photo,
    required this.gender,
    required this.phone,
    required this.id,
    required this.appointments,
    required this.token,
  });
}
