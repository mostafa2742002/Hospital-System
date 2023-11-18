import "package:flutter/material.dart";
import 'package:hospital/patients/components/doctor_card.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          children: [
            Text(
              'My Favorite Doctors',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: DoctorCard(
                doctor: {},
                isFav: true,
              ),

              //child:
            ),
          ],
        ),
      ),
    );
  }
}
