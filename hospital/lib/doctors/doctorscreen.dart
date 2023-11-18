import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hospital/models/doctorModel.dart';
import 'package:hospital/patients/screens/appointment_screen.dart';

import '../models/upCommingAppointments.dart';

class DoctorScreen extends StatefulWidget {
  final Doctor doctor;
  final List<upCommingAppointment>? appointments;
  DoctorScreen({super.key, required this.doctor, this.appointments});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  @override
  Widget build(BuildContext context) {
    final Uint8List bytes = base64Decode(widget.doctor.photo);
    MemoryImage image = MemoryImage(bytes);
    print(widget.appointments!.length);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.blue,
        leadingWidth: 30,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Dr. ${widget.doctor.fullname}",
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: CircleAvatar(
                radius: 25,
                backgroundImage: image,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            16.0), // Add padding for better spacing
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100], // Set a background color
                          borderRadius: BorderRadius.circular(
                              10.0), // Add rounded corners
                        ),
                        child: Text(
                          'Upcoming Appointments',
                          style: TextStyle(
                            fontSize: 24, // Increase font size for emphasis
                            fontWeight: FontWeight.bold,
                            color: Colors.teal, // Change text color
                            shadows: [
                              Shadow(
                                color: Colors.grey,
                                offset:
                                    Offset(2, 2), // Add a subtle shadow effect
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: ListView.builder(
                          itemCount: widget.appointments!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                        "assets/doctor1.jpg",
                                      ),
                                    ),
                                    title: Text(
                                      widget.appointments![index].patient
                                          .fullname,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      widget.appointments![index].appointment
                                          .date,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => UpdateDataDoctor(
                                        //         doctor: widget.doctors![index],
                                        //         admin : widget.doctor,
                                        //         ),
                                        //   ),
                                        // );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                              ),
                            );

                            // ...
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Add more sections or widgets for other relevant information
            ],
          ),
        ),
      ),
    );
  }
}
