import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hospital/admin/screens/admin_main_layout.dart';
import 'package:hospital/models/patient.dart';
import 'package:hospital/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:hospital/components/button.dart';
import 'package:http/http.dart' as http;

class UpdateDataPatient extends StatefulWidget {
  final Patient patient;
  const UpdateDataPatient({super.key, required this.patient});

  @override
  State<UpdateDataPatient> createState() => _UpdateDatapatientState();
}

class _UpdateDatapatientState extends State<UpdateDataPatient> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  File? image;
  String? base64Image = 'null';

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
        ConvertImage(imageTemporary);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future ConvertImage(File image) async {
    Uint8List imageBytes = await image.readAsBytes();
    base64Image = base64Encode(imageBytes);
    print(base64Image);
  }

  @override
  void initState() {
    _nameController.text = widget.patient!.fullname;
    _emailController.text = widget.patient!.email;
    _phoneController.text = widget.patient!.phone;
    _passwordController.text = widget.patient!.password;
    _ageController.text = widget.patient!.age;
    _genderController.text = widget.patient!.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update patient Data'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: image != null ? FileImage(image!) : null,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(33, 150, 243, 1),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Button(
                  width: 400,
                  color: Colors.black,
                  title: 'Change Profle Picture',
                  onPressed: () {
                    pickImage();
                  },
                  disable: false,
                  height: 50),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'phone'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'age'),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(33, 150, 243, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Button(
                  width: 400,
                  color: Colors.green,
                  title: 'Save Data',
                  onPressed: () {
                    _updatepatient(
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _phoneController.text,
                        _ageController.text,
                        base64Image!,
                        widget.patient!.token,
                        context);
                  },
                  disable: false,
                  height: 50),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 0, 0, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Button(
                  width: 400,
                  color: Colors.red,
                  title: 'delete patient',
                  onPressed: () {
                    _deletepatient(
                        _emailController.text, widget.patient!.token, context);
                  },
                  disable: false,
                  height: 50),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> _updatepatient(
    String name,
    String email,
    String password,
    String phone,
    String age,
    String base64Image,
    String token,
    BuildContext context) async {
  final Uri api = Uri.parse('http://192.168.43.45:3000/patient/updatepatient');
  try {
    final response = await http.post(api, body: {
      'email': email,
      'password': password,
      'fullname': name,
      'age': age,
      'phone': phone,
      'photo': base64Image,
      'token': token,
      'id': 'sasa',
    });
    if (response.statusCode == 200) _showpatientCreatedDialog(context);
  } catch (e) {
    print(e);
  }
}

void _showpatientCreatedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('patient Created'),
        content: const Text('The patient has been updated successfully.'),
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

Future<dynamic> _deletepatient(
    String email, String token, BuildContext context) async {
  final Uri api = Uri.parse('http://192.168.43.45:3000/patient/deletepatient');
  try {
    final response = await http.post(api, body: {
      'email': email,
      'token': token,
      'id': 'sasa',
    });
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
        ),
      );
    }
    // _showpatientDeletedDialog(context);
  } catch (e) {
    print(e);
  }
}

void _showpatientDeletedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('patient Deleted'),
        content: const Text('The patient has been deleted successfully.'),
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
