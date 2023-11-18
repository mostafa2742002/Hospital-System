import 'package:flutter/material.dart';
import 'package:hospital/components/button.dart';
import 'package:hospital/models/doctorModel.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital/components/social_button.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/signup_screen.dart';

import '../models/Appointment.dart';

class CreateAvailableTime extends StatefulWidget {
  final Doctor doctor;
  const CreateAvailableTime({super.key, required this.doctor});

  @override
  State<CreateAvailableTime> createState() => _CreateAvailableTimeState();
}

class _CreateAvailableTimeState extends State<CreateAvailableTime> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _descriptionController = TextEditingController();

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Available Time'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: MediaQuery.of(context).size.width > 600
              ? const EdgeInsets.symmetric(horizontal: 300)
              : const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                    'Select Date: ${_selectedDate.toString().split(' ')[0]}'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text('Select Time: ${_selectedTime.format(context)}'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.06),
                child: Image.asset(
                  "assets/doctors.png",
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(33, 150, 243, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Button(
                    width: 400,
                    color: const Color.fromRGBO(33, 150, 243, 1),
                    title: 'Create Available Time',
                    onPressed: () {
                      _makeAppointment(
                          _selectedDate, _selectedTime, widget.doctor);
                    },
                    disable: false,
                    height: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _makeAppointment(
    DateTime date, TimeOfDay time, Doctor doctor) async {
  final Uri api =
      Uri.parse('http:// 192.168.43.45:3000/doctor/createoppointment');

  final newAppointment = Appointment(
    date: date.toString().split(' ')[0],
    time: time.toString().split(' ')[0],
    status: 'free',
    doctorId: doctor.id,
    patientId: '',
    Id: '',
  );

  try {
    final newAppointmentJson = newAppointment.toJson();

    final response = await http.post(api, body: {
      'email': doctor.email,
      'appointment': jsonEncode(newAppointmentJson),
      'token': doctor.token,
      '_id': doctor.id,
    });

    if (response.statusCode == 200) {
      // Handle success, maybe show a success message
      doctor.appointments.add(newAppointment);
      print('Appointment created successfully');
    } else {
      // Handle error, maybe show an error message
      print('Failed to create appointment');
    }
  } catch (e) {
    print(e);
  }
}
