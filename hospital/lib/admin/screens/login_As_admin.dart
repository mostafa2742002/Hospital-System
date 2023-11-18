import 'package:flutter/material.dart';
import 'package:hospital/models/Admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_verification_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _sendVerificationEmail(String email, Admin admin) async {
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
              email: _emailController.text,
              password: _passwordController.text,
              admin: admin,
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

  Future<dynamic> _loginUSer(
      String email, String password, BuildContext context) async {
    final Uri api = Uri.parse('http://192.168.95.25:3000/admin/login');
    try {
      final response = await http.post(api, body: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final result = jsonData['result'];
        _sendVerificationEmail(email, _loginAsAdmin(context, result));
      } else {
        var message = json.decode(response.body)['message'];
        _showErrorDialog(context, message);
      }
    } catch (e) {
      print(e);
    }
  }

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Enter Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                await _loginUSer(
                    _emailController.text, _passwordController.text, context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
              ),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Ok'),
        ),
      ],
    ),
  );
}

Admin _loginAsAdmin(BuildContext context, dynamic result) {
  final admin = Admin(
    fullname: result['admin']['fullname'] ?? 'not found',
    email: result['admin']['email'] ?? 'not found',
    password: result['admin']['password'] ?? 'not found',
    phone: result['admin']['phone'] ?? 'not found',
    id: result['admin']['_id'] ?? 'not found',
    gender: result['admin']['gender'] ?? 'not found',
    age: result['admin']['age'] ?? 'not found',
    token: result['token'] ?? 'not found',
    photo: result['admin']['photo'] ?? 'assets/profile1.jpg',
  );
  return admin;
}
