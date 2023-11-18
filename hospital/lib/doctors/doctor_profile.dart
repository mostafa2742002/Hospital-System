import "dart:convert";
import "dart:typed_data";
import "package:flutter/material.dart";
import "package:hospital/models/doctorModel.dart";
import "../../login_screen.dart";


class ProfilePage extends StatefulWidget {
  final Doctor doctor;
    const ProfilePage({Key? key , required this.doctor}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final Uint8List bytes = base64Decode(widget.doctor.photo);
    MemoryImage image = MemoryImage(bytes);
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            color:   const Color(0XFF0080FE),
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
                  'Dr. ${widget.doctor.fullname}',
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
                  '${widget.doctor.age} | ${widget.doctor.gender}',
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
                              child:   const Text(
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
