import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hospital/admin/screens/admin_profile.dart';
import 'package:hospital/login_screen.dart';
import 'package:hospital/models/Admin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:hospital/components/button.dart';
import 'package:http/http.dart' as http;

class UpdateDataAdmin extends StatefulWidget {
  final Admin? admin;
  const UpdateDataAdmin({super.key, this.admin});

  @override
  State<UpdateDataAdmin> createState() => _UpdateDataAdminState();
}

class _UpdateDataAdminState extends State<UpdateDataAdmin> {
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
    _nameController.text = widget.admin!.fullname;
    _emailController.text = widget.admin!.email;
    _phoneController.text = widget.admin!.phone;
    _passwordController.text = widget.admin!.password;
    _ageController.text = widget.admin!.age;
    _genderController.text = widget.admin!.gender;
    super.initState();
  }

  Widget build(BuildContext context) {
    final adminimage;

    if (widget.admin?.photo != 'null') {
      final Uint8List bytes = base64Decode(widget.admin!.photo);
      adminimage = MemoryImage(bytes);
    } else {
      adminimage = AssetImage("assets/default.jpg");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Admin Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: InkWell(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      image != null ? FileImage(image!) : adminimage,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(33, 150, 243, 1),
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Button(
                color: Colors.green,
                width: 400,
                title: 'Change Profile Picture',
                onPressed: () {
                  pickImage();
                },
                disable: false,
                height: 50,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(_nameController, 'Name'),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email'),
            const SizedBox(height: 16),
            _buildTextField(_passwordController, 'Password'),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, 'Phone'),
            const SizedBox(height: 16),
            _buildTextField(_ageController, 'Age'),
            _buildTextField(_genderController, 'Gender'),
            const SizedBox(height: 24),
            _buildButton(
              'Save Data',
              () {
                _updateAdmin(
                  _nameController.text,
                  _emailController.text,
                  _passwordController.text,
                  _phoneController.text,
                  _ageController.text,
                  _genderController.text,
                  base64Image!,
                  widget.admin!.token,
                  widget.admin!.id,
                  context,
                );
              },
              50,
              Colors.green,
            ),
            const SizedBox(height: 24),
            _buildButton(
              'Delete Admin',
              () {
                _deleteAdmin(
                    _emailController.text, widget.admin!.token, context);
              },
              50,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildButton(
    String title,
    VoidCallback onPressed,
    double height,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Button(
        color: color,
        width: 400,
        title: title,
        onPressed: onPressed,
        disable: false,
        height: height,
      ),
    );
  }

  Future<dynamic> _updateAdmin(
    String name,
    String email,
    String password,
    String phone,
    String age,
    String gender,
    String base64Image,
    String token,
    String id,
    BuildContext context,
  ) async {
    final Uri api = Uri.parse('http://192.168.95.25:3000/admin/edit');
    try {
      final response = await http.post(api, body: {
        'email': email,
        'password': password,
        'fullname': name,
        'gender': gender,
        'age': age,
        'phone': phone,
        'photo': base64Image,
        'token': token,
        'id': id,
      });
      var message = jsonDecode(response.body)['message'];
      if (response.statusCode == 200) {
        _showAdminCreatedDialog(context, "Done", message);
      } else {
        _showAdminCreatedDialog(context, "ERROR", message);
      }
    } catch (e) {
      print(e);
    }
  }

  void _showAdminCreatedDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Admin Updated'),
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

  Future<dynamic> _deleteAdmin(
    String email,
    String token,
    BuildContext context,
  ) async {
    final Uri api = Uri.parse('http://192.168.95.25:3000/admin/deleteAdmin');
    try {
      final response = await http.post(api, body: {
        'email': email,
        'token': token,
        'id': 'sasa',
      });
      var message = jsonDecode(response.body)['message'];
      if (response.statusCode == 200) {
        _showAdminCreatedDialog(context, "Done", message);
      } else {
        _showAdminCreatedDialog(context, "ERROR", message);
      }
    } catch (e) {
      print(e);
    }
  }

  void _showAdminDeletedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Admin Deleted'),
          content: const Text('The Admin has been deleted successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                MaterialPageRoute(builder: (context) => loginScreen());
              },
            ),
          ],
        );
      },
    );
  }
}
