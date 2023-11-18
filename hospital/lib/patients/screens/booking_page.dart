import 'package:flutter/material.dart';
import 'package:hospital/models/doctorModel.dart';
import 'package:hospital/models/patient.dart';
import 'package:http/http.dart' as http;
import '../../models/Appointment.dart';

class AppointmentsPage extends StatefulWidget {
  final Doctor doctor;
  final Patient patient;
  AppointmentsPage({required this.doctor, required this.patient});

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Appointment> freeAppointments = [];

  @override
  void initState() {
    super.initState();
    filterFreeAppointments();
  }

  void filterFreeAppointments() {
    setState(() {
      freeAppointments = widget.doctor.appointments
          .where((appointment) => appointment.status == 'free')
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Free Appointments'),
      ),
      body: ListView.builder(
        itemCount: freeAppointments.length,
        itemBuilder: (context, index) {
          Appointment appointment = freeAppointments[index];
          return ListTile(
            title: Text('Date: ${appointment.date}, Time: ${appointment.time}'),
            subtitle: Text('Status: ${appointment.status}'),
            onTap: () {
              _bookAppointment(
                  appointment, widget.patient, widget.doctor, context);
            },
            // Add any other UI elements you want to display for each appointment
          );
        },
      ),
    );
  }
}

Future<void> _bookAppointment(Appointment appointment, Patient patient,
    Doctor doctor, BuildContext context) async {
  final Uri api =
      Uri.parse('http://192.168.43.45:3000/patient/bookappointment');
  try {
    final response = await http.post(api, body: {
      'appointmentid': appointment.Id,
      'doctorid': doctor.id,
      'patientid': patient.id,
    });
    _showChangepaswordDialog(context);
  } catch (e) {
    print(e);
  }
}

void _showChangepaswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('book Appointment'),
        content: const Text('booked Appointment Successfully'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
