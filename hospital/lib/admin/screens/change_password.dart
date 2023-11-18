import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital/admin/screens/PasswordChangeVerification.dart';
import 'package:hospital/admin/screens/admin_verification_screen.dart';
import 'package:hospital/models/Admin.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  final Admin admin;
  const ChangePassword({Key? key, required this.admin}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
            builder: (context) => PasswordVerification(
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
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPasswordField(
                controller: _currentPasswordController,
                labelText: 'Current Password',
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _newPasswordController,
                labelText: 'New Password',
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _confirmPasswordController,
                labelText: 'Confirm New Password',
              ),
              const SizedBox(height: 24),
              _buildChangePasswordButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(33, 150, 243, 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: () {
          _changePassword(
            _currentPasswordController.text,
            _newPasswordController.text,
            _confirmPasswordController.text,
            widget.admin,
            widget.admin.token.toString(),
            context,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Change Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
    Admin admin,
    String token,
    BuildContext context,
  ) async {
    final api = Uri.parse('http://192.168.95.25:3000/admin/changepassword');
    try {
      final response = await http.post(api, body: {
        'oldpassword': currentPassword,
        'newpassword': newPassword,
        'confirmpassword': confirmPassword,
        'id': admin.id.toString(),
        'token': token.toString(),
      });
      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        _sendVerificationEmail(admin.email);
      } else
        _showChangePasswordDialog(context, jsonData['message']);
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
