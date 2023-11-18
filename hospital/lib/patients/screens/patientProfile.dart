import "dart:convert";
import "dart:typed_data";

import "package:flutter/material.dart";
import 'package:hospital/patients/screens/editdataPatient.dart';
import "package:hospital/patients/screens/change_password.dart";
import "../../login_screen.dart";
import '../../models/patient.dart';

class ProfilePage extends StatefulWidget {
  final Patient patient;
  const ProfilePage({Key? key, required this.patient}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final image;

    if (widget.patient.photo != 'null') {
      final Uint8List bytes = base64Decode(widget.patient.photo);
      image = MemoryImage(bytes);
    } else {
      image = AssetImage("assets/default.jpg");
    }
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            color: const Color(0XFF0080FE),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                CircleAvatar(
                  radius: 65.0,
                  backgroundImage: image,
                  backgroundColor: Colors.white,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  '${widget.patient.fullname}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  // '21 | male',
                  '${widget.patient.age} | ${widget.patient.gender}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.grey[200],
            child: Center(
              child: Card(
                margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Padding(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.blueAccent[400],
                              size: 35,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateDataPatient(
                                      patient: widget.patient,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(
                                  color: Color(0XFF0080FE),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.history,
                              color: Color(0XFF0080FE),
                              size: 35,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangePassword(
                                      patient: widget.patient,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Change Password",
                                style: TextStyle(
                                  color: Color(0XFF0080FE),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.logout_outlined,
                              color: Color(0XFF0080FE),
                              size: 35,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            TextButton(
                              onPressed: () {
                                // sent to login page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const loginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                  color: Color(0XFF0080FE),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
