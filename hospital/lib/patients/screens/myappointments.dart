import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hospital/models/patient.dart';

import '../../models/doctorModel.dart';


class MyDoctorsScreen extends StatelessWidget {
  final Patient patient;
  final List<Doctor> myDoctors;

  MyDoctorsScreen({required this.patient, required this.myDoctors});
  _doctorPhoto(Doctor doctor)
  {
    if (doctor.photo != 'null') {
      final Uint8List bytes = base64Decode(doctor.photo);
      return MemoryImage(bytes);
    } else {
      return AssetImage("assets/default.jpg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Booked Doctors'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${patient.fullname}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Here are the doctors you have appointments with:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: myDoctors.length,
                itemBuilder: (context, index) {
                  Doctor doctor = myDoctors[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: _doctorPhoto(doctor),

                    ),
                    title: Text(
                      'Dr. ${doctor.fullname}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      doctor.Specialization,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      // Navigate to doctor's details or appointment details screen
                      // You can implement the navigation here
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
