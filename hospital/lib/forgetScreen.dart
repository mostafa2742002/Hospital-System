import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hospital/verificationForgetPassword.dart';
import 'package:http/http.dart' as http;

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final TextEditingController _emailController = TextEditingController();
  Future<void> _sendVerificationEmail(String email) async {
    final Uri api =
        Uri.parse('http://192.168.43.45:3000/admin/send-verification-email');

    try {
      final response = await http.post(api, body: {
        'email': email,
      });
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForegtVerification(
              email: email,
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
      appBar: AppBar(
        title: const Text('Forget Password'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Enter your email to reset your password',
                style: TextStyle(
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter email",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!_emailController.text.isEmpty) {
                    _sendVerificationEmail(_emailController!.text);
                    verify(_emailController!.text, context);
                  }
                },
                child: _emailController.text.isEmpty
                    ? const Text('Enter Email')
                    : const Text('Send Verification Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> verify(String email, BuildContext context) async {
  final Uri api = Uri.parse('http://192.168.43.45:3000/forgotPassword');
  try {
    final response = await http.post(api, body: {
      'email': email,
    });
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForegtVerification(email: email),
        ),
      );
    }
  } catch (e) {
    print(e);
  }
}
