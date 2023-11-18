import 'package:flutter/material.dart';
import 'package:hospital/admin/screens/admin_main_layout.dart';
import 'package:hospital/models/Admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_home_screen.dart';
import 'PasswordChangeVerification.dart';
import 'login_As_admin.dart';

class AdminVerificationScreen extends StatefulWidget {
  final String email;
  final String password;
  final Admin admin;
  const AdminVerificationScreen({
    required this.email,
    required this.password,
    required this.admin,
  });

  @override
  _AdminVerificationScreenState createState() =>
      _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  final List<FocusNode> _pinFocusNodes =
      List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _pinControllers =
      List.generate(6, (index) => TextEditingController());

  Future<void> _verifyCode(String email, String password, String code) async {
    final Uri api = Uri.parse('http://192.168.95.25:3000/admin/verify-code');

    try {
      final response = await http.post(api, body: {
        'email': email,
        'password': password,
        'code': code,
      });

      final jsonData = json.decode(response.body);
      if (jsonData['success']) {
        _loginAsAdmin(email, password);
      } else {
        _showErrorDialog(context, "Error Occured!!", "Invalid Code");
      }
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
            builder: (context) => AdminVerificationScreen(
              email: email,
              password: widget.password,
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
                width: widget.email.length * 13,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.email}',
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
                        await _sendVerificationEmail(widget.email);
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
                  widget.email,
                  widget.password,
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

  void _loginAsAdmin(String email, String password) async {
    try {
      final admin = widget.admin;

      if (admin != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminLayuot(
                    admin: admin,
                  )),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Admin?> getAdminDataByEmail(String email) async {
    final Uri api = Uri.parse('http://192.168.95.25:3000/admin/getData');
    try {
      final response = await http.post(api, body: {
        'email': email,
      });
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final result = jsonData['result'];

        return Admin(
          fullname: result['fullname'] ?? 'not found',
          email: result['email'] ?? 'not found',
          password: result['password'] ?? 'not found',
          phone: result['phone'] ?? 'not found',
          id: result['_id'] ?? 'not found',
          gender: result['gender'] ?? 'not found',
          age: result['age'] ?? 'not found',
          token: result['token'] ?? 'not found',
          photo: result['photo'] ?? 'null',
        );
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
