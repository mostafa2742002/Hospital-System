import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hospital/admin/screens/admin_profile.dart';

import '../../models/Admin.dart';

class AdminScreen extends StatelessWidget {
  final Admin admin;

  const AdminScreen({Key? key, required this.admin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final containerWidth = MediaQuery.of(context).size.width;
    final containerHeight = MediaQuery.of(context).size.height;

    final image = _getAdminImage();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.blue,
        leadingWidth: 30,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: containerWidth * 0.01),
              child: Text(
                "Admin panel",
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.343),
            Container(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        admin: admin,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: image,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/doctors.png"),
            SizedBox(height: containerHeight * 0.1),
            _buildWelcomeText("Welcome admin"),
            SizedBox(
              height: 15,
            ),
            _buildWelcomeText("You can make CRUD now"),
          ],
        ),
      ),
    );
  }

  ImageProvider _getAdminImage() {
    if (admin.photo != 'null') {
      final Uint8List bytes = base64Decode(admin.photo);
      return MemoryImage(bytes);
    } else {
      return AssetImage("assets/default.jpg");
    }
  }

  Container _buildWelcomeText(String text) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: "Fixedsys",
          // fontStyle: FontStyle.italic,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
