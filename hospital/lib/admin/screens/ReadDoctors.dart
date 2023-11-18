import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hospital/admin/screens/update_data_doctor.dart';
import 'package:hospital/models/Admin.dart';
import 'package:http/http.dart' as http;
import '../../models/doctorModel.dart';

class ReadDoctors extends StatefulWidget {
  final Admin admin;
  List<Doctor>? doctors;
  ReadDoctors({super.key, required this.admin, required this.doctors});

  @override
  State<ReadDoctors> createState() => _ReadDoctorsState();
}

class _ReadDoctorsState extends State<ReadDoctors> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "General",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Cardiology",
    },
    {
      "icon": FontAwesomeIcons.lungs,
      "category": "Respirations",
    },
    {
      "icon": FontAwesomeIcons.hand,
      "category": "Dermatology",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "category": "Gynecology",
    },
    {
      "icon": FontAwesomeIcons.teeth,
      "category": "Dental",
    },
  ];
  List<Doctor> _filteredElements = [];

  @override
  void initState() {
    super.initState();
    _filteredElements =
        List.from(widget.doctors!); // Initialize with all doctors initially
    _filterElements(medCat[_selectedIndex]["category"]);
  }

  void _filterElements(String choice) {
    List<Doctor> doctors = widget.doctors!;
    List<Doctor> filtered = [];
    for (int i = 0; i < doctors.length; i++) {
      Doctor doctor = doctors[i];
      if (doctor.Specialization == choice) {
        filtered.add(doctor);
      }
    }

    setState(() {
      _filteredElements = filtered;
    });
  }

  ImageProvider _getAdminImage(Doctor doctor) {
    try {
      if (doctor.photo != 'null') {
        final Uint8List bytes = base64Decode(doctor.photo);
        return MemoryImage(bytes);
      } else {
        return AssetImage("assets/default.jpg");
      }
    } catch (e) {
      print("Image decoding error: $e");
      return AssetImage("assets/default.jpg");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.doctors);
    final adminimage;
    if (widget.admin.photo != 'null') {
      final Uint8List bytes = base64Decode(widget.admin.photo);
      adminimage = MemoryImage(bytes);
    } else {
      adminimage = AssetImage("assets/default.jpg");
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.blue,
        leadingWidth: 30,
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Hospital System",
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.251),
            InkWell(
              onTap: () {},
              child: CircleAvatar(
                radius: 25,
                backgroundImage: adminimage,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Category',
                
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF0080FE),
                ),
              ),
            ),
            Container(
              height: 50, // Set a fixed height for better UI
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: medCat.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        _filterElements(medCat[index]["category"]);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIndex == index
                            ? Theme.of(context).primaryColor
                            : Colors.green,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FaIcon(
                            medCat[index]['icon'],
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            medCat[index]["category"],
                            style: TextStyle(
                              color: _selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Doctors',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF0080FE),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: _filteredElements.isEmpty
                  ? Center(
                      child: Text(
                        'No doctors found',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredElements.length,
                      itemBuilder: (context, index) {
                        Doctor doctor = _filteredElements[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: Colors.grey.shade300, width: 1.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateDataDoctor(
                                      doctor: doctor,
                                      admin: widget.admin,
                                      doctors: widget.doctors!,
                                    ),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                radius: 30.0,
                                backgroundImage: _getAdminImage(doctor),
                              ),
                              title: Text(
                                doctor.fullname,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                doctor.Specialization,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.blue,
                                size: 16.0,
                              ),
                            ),
                          ),
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
