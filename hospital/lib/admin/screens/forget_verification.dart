import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital/components/social_button.dart';
import 'package:hospital/patients/components/main_layout.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/signup_screen.dart';

class ForgetVerification extends StatelessWidget {
  final String email;
  ForgetVerification({super.key, required this.email});
  final List<FocusNode> _pinFocusNodes =
      List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _pinControllers =
      List.generate(6, (index) => TextEditingController());

  Future<void> _sendVerificationEmail(String email) async {
    final Uri api =
        Uri.parse('http://192.168.95.25:3000/admin/send-verification-email');

    try {
      final response = await http.post(api, body: {
        'email': email,
      });
      if (response.statusCode == 200) {
        // Navigator.push(
        //   co
        //   //  as BuildContext,
        //   MaterialPageRoute(
        //     builder: (context) => ForgetVerification(
        //       email: email,
        //     ),
        //   ),
        // );
      }
      final jsonData = json.decode(response.body);
      print(jsonData['message']);
    } catch (e) {
      print(e);
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              // clear the pin code
              for (var controller in _pinControllers) {
                controller.clear();
              }
              Navigator.pop(context);
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyCode(String email, String password, String code) async {
    final Uri api =
        Uri.parse('http://192.168.95.25:3000/admin/verify-code_forget');

    try {
      final response = await http.post(api, body: {
        'email': email,
        'code': code,
      });

      final jsonData = json.decode(response.body);
      // if (jsonData['success']) {
      //   _showErrorDialog(
      //       context, "Error Occured!!", "Invalid Code");
      // } else {
      //   _showErrorDialog(
      //       context as BuildContext, "Error Occured!!", "Invalid Code");
      // }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Enter verification code sent to',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 5),
              child: Container(
                alignment: Alignment.center,
                width: email.length * 13,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${email}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.greenAccent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _pinControllers[index],
                    focusNode: _pinFocusNodes[index],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 5) {
                          _pinFocusNodes[index + 1].requestFocus();
                        } else {
                          _pinFocusNodes[index].unfocus();
                        }
                      }
                    },
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      counterText: '',
                    ),
                  ),
                );
              }),
            ),
            // SizedBox(height: 40)
            // make button for resend code and align it to the right
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Didn\'t receive code?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        await _sendVerificationEmail(email);
                      },
                      child: Text(
                        'Resend',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      )),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String verificationCode = '';
                for (var controller in _pinControllers) {
                  verificationCode += controller.text;
                }
                print(verificationCode);
                // await _verifyCode(
                //   widget.email,
                //   widget.password,
                //   verificationCode,
                // );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
              ),
              child: Text('Verify Code'),
            ),
          ],
        ),
      ),
    );
  }
}
