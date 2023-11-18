import 'package:flutter/material.dart';
import 'package:hospital/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordChangeVerification extends StatefulWidget {
  final String email;
  PasswordChangeVerification({Key? key, required this.email}) : super(key: key);

  @override
  State<PasswordChangeVerification> createState() =>
      _PasswordChangeVerificationState();
}

class _PasswordChangeVerificationState
    extends State<PasswordChangeVerification> {
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  void _changePasswordForget() {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
    } else {
      _changePassword(
        newPassword,
        confirmPassword,
        context,
      );
    }
  }

  Future<void> _changePassword(
    String newPassword,
    String confirmPassword,
    BuildContext context,
  ) async {
    final api = Uri.parse('http://192.168.43.45:3000/change_password');
    try {
      final response = await http.post(api, body: {
        'email': widget.email,
        'password': confirmPassword,
      });
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password changed successfully'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => loginScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password change failed'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _newPasswordController,
              obscureText: !_showNewPassword,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                  icon: Icon(
                    _showNewPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_showConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _showConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePasswordForget,
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
