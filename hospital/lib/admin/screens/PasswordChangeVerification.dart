import 'dart:convert';
import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:hospital/admin/screens/admin_home_screen.dart';
import 'package:hospital/admin/screens/admin_main_layout.dart';
import 'package:hospital/models/Admin.dart';
import 'package:hospital/welcome_screen.dart';
import 'package:http/http.dart' as http;
import 'admin_home_screen.dart';
import 'PasswordChangeVerification.dart';
import 'login_As_admin.dart';

class PasswordVerification extends StatefulWidget {
  PasswordVerification({super.key, required this.admin});
  final Admin admin;
  @override
  State<PasswordVerification> createState() => _PasswordVerificationState();
}

class _PasswordVerificationState extends State<PasswordVerification> {
  final TextEditingController _verificationCodeController =
      TextEditingController();
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordVerification(
              // email: email,
              // password: widget.admin.password,
              admin: widget.admin,
            ),
          ),
        );
      }
      final jsonData = json.decode(response.body);
      print(jsonData['message']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _verifyCode(String email, String password, String code) async {
    final Uri api = Uri.parse('http://192.168.95.25:3000/admin/verify-code');

    try {
      final response = await http.post(api, body: {
        'email': email,
        'password': password,
        'code': code,
      });
      print(response.body);
      final jsonData = json.decode(response.body);
      print(email);
      if (jsonData['success']) {
        _showChangePasswordDialog(context, 'Password Changed Successfully');
      } else {
        print('Admin data not found');
      }
    } catch (e) {
      print(e);
    }
  }

  void _showChangePasswordDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminLayuot(
                      admin: widget.admin,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Verification')),
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
                width: widget.admin.email.length * 13,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.admin.email}',
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
                        await _sendVerificationEmail(widget.admin.email);
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
                await _verifyCode(
                  widget.admin.email,
                  widget.admin.password,
                  verificationCode,
                );
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
