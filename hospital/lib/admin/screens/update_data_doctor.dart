import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hospital/admin/screens/ReadDoctors.dart';
import 'package:hospital/admin/screens/admin_home_screen.dart';
import 'package:hospital/admin/screens/admin_main_layout.dart';
import 'package:hospital/models/Admin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:hospital/components/button.dart';
import 'package:http/http.dart' as http;

import '../../models/doctorModel.dart';

class UpdateDataDoctor extends StatefulWidget {
  final Doctor? doctor;
  final Admin admin;
  final List<Doctor> doctors;
  const UpdateDataDoctor(
      {super.key, this.doctor, required this.admin, required this.doctors});

  @override
  State<UpdateDataDoctor> createState() => _UpdateDataDoctorState();
}

class _UpdateDataDoctorState extends State<UpdateDataDoctor> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female', 'Other'];
  File? image;
  String? base64Image;
  String? _selectedSpecialization;
  final List<String> _specialization = [
    'General',
    'Cardiology',
    'Respirations',
    'Dermatology',
    'Gynecology',
    'Dental'
  ];
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

  Widget _buildDropdownField({
    required String? value,
    required void Function(String?)? onChanged,
    required List<DropdownMenuItem<String>> items,
    required String labelText,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items,
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

  @override
  void initState() {
    _nameController.text = widget.doctor!.fullname;
    _emailController.text = widget.doctor!.email;
    _specializationController.text = widget.doctor!.Specialization;
    _selectedGender = widget.doctor?.gender;
    _phoneController.text = widget.doctor!.phone;
    _addressController.text = widget.doctor!.address;
    _aboutController.text = widget.doctor!.aboutDoctor;
    _priceController.text = widget.doctor!.price;
    _passwordController.text = widget.doctor!.password;
    _ageController.text = widget.doctor!.age;
    _selectedSpecialization = widget.doctor!.Specialization;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.doctor!.id);
    final doctorimage;
    if (widget.doctor?.photo != 'null') {
      final Uint8List bytes = base64Decode(widget.doctor!.photo);
      doctorimage = MemoryImage(bytes);
    } else {
      doctorimage = AssetImage("assets/default.jpg");
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Doctor Data'),
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
                      image != null ? FileImage(image!) : doctorimage,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(33, 150, 243, 1),
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Button(
                color: Colors.green,
                width: 400,
                title: 'Change Profle Picture',
                onPressed: () {
                  pickImage();
                },
                disable: false,
                height: 50,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _aboutController,
              decoration: const InputDecoration(
                labelText: 'About the doctor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              value: _specializationController.text,
              onChanged: (newValue) {
                setState(() {
                  _selectedSpecialization = newValue;
                });
              },
              items: _specialization.map((specialization) {
                return DropdownMenuItem<String>(
                  value: specialization,
                  child: Text(specialization),
                );
              }).toList(),
              labelText: 'Specialization',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              items: _genders.map((gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(33, 150, 243, 1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Button(
                color: Colors.green,
                width: 400,
                title: 'Save Data',
                onPressed: () {
                  _updateDoctor(
                    _nameController.text,
                    _selectedSpecialization.toString(),
                    _selectedGender.toString(),
                    _emailController.text,
                    _passwordController.text,
                    _phoneController.text,
                    base64Image == null
                        ? widget.doctor!.photo
                        : base64Image.toString(),
                    _aboutController.text,
                    _priceController.text,
                    _addressController.text,
                    widget.admin.token,
                    widget.admin.id,
                    _ageController.text,
                    context,
                  );
                },
                disable: false,
                height: 50,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 0, 0, 1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Button(
                color: Colors.red,
                width: 400,
                title: 'Delete Doctor',
                onPressed: () {
                  _deleteDoctor(
                    widget.doctor!.email,
                    widget.admin.token,
                  );
                },
                disable: false,
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _updateDoctor(
    String name,
    String specialization,
    String gender,
    String email,
    String password,
    String phone,
    String base64Image,
    String aboutDoctor,
    String price,
    String address,
    String token,
    String id,
    String age,
    BuildContext context,
  ) async {
    final Uri api = Uri.parse('http://192.168.95.25:3000/admin/updatedoctor');
    try {
      final response = await http.post(api, body: {
        'email': email,
        'password': password,
        'fullname': name,
        'gender': gender,
        'Specialization': specialization,
        'phone': phone,
        'photo': base64Image,
        'aboutDoctor': aboutDoctor,
        'address': address,
        'token': token,
        'id': id,
        'Price': price,
        'age': age,
      });
      // update data doctor in the list
      if (response.statusCode == 200) {
        widget.doctors
            .removeWhere((element) => element.email == widget.doctor!.email);
        widget.doctors.add(Doctor(
            fullname: name,
            Specialization: specialization,
            phone: phone,
            password: password,
            email: email,
            gender: gender,
            id: id,
            address: address,
            aboutDoctor: aboutDoctor,
            price: price,
            photo: base64Image,
            age: age,
            appointments: [],
            token: ''));
        _showDoctorDeletedDialog(
            "Doctor Updated", "Doctor has been updated successfully.", context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ReadDoctors(
        //       admin: widget.admin,
        //       doctors: widget.doctors,
        //     ),
        //   ),
        // );
      }
      print(response.body);
      // _showDoctorCreatedDialog(context);
    } catch (e) {
      print(e);
    }
  }

  void _showDoctorCreatedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Doctor Created'),
          content: const Text('The doctor has been updated successfully.'),
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

  Future<dynamic> _deleteDoctor(
    String email,
    String token,
  ) async {
    final Uri api = Uri.parse('http://192.168.95.25:3000/admin/deletedoctor');
    try {
      final response = await http.post(api, body: {
        'email': email,
        'token': token,
      });

      print(email);
      print(response.body);
      if (response.statusCode == 200) {
        widget.doctors.clear();
        _showDoctorDeletedDialog("Doctor Deleted",
            "The doctor has been deleted successfully.", context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminLayuot(
              admin: widget.admin,
            ),
          ),
        );
      } else
        _showDoctorDeletedDialog("Error", "Something went wrong.", context);
    } catch (e) {
      print(e);
    }
  }

  void _showDoctorDeletedDialog(
      String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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
