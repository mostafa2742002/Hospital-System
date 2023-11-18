import 'package:flutter/material.dart';
import 'package:hospital/patients/screens/appointment_screen.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.isFav,
  }) : super(key: key);

  final Map<String, dynamic> doctor;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Container(
            width: 350,
            // Set the desired width for the item
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(vertical: 180),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage("assets/doctor1.jpg"),
                ),
                Text(
                  "Dr. Menna Elyamany",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0XFF0080FE),
                  ),
                ),
                Text(
                  "Heart Doctor",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    Text(
                      "4.9",
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       // builder: (context) => const AppointmentScreen(),
          //     ));
        },
      ),
    );
  }
}
