import 'package:flutter/material.dart';
import 'package:hospital/admin/screens/login_As_admin.dart';
import 'package:hospital/login_screen.dart';
import 'package:hospital/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.06),
                child: Image.asset(
                  "assets/doctors.png",
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              const Center(
                child: Text(
                  "Hospital System",
                  style: TextStyle(
                    color: Color.fromARGB(255, 99, 190, 102),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    wordSpacing: 2,
                  ),
                ),
              ),
              // const SizedBox(height: 5),
              const Text(
                "Appoint Your Doctor",
                style: TextStyle(
                  color: Color.fromARGB(255, 126, 159, 175),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    color: Colors.greenAccent[700],
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const loginScreen(),
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 40),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.greenAccent[700],
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 40),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminLoginScreen(),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    child: const Text(
                      "Login as Admin",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
