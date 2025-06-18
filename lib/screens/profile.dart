import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testproject/helpers/cart_helper.dart';
import 'package:testproject/models/order.dart';
import 'package:testproject/screens/splash.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String address = '';
  String gender = '';
  String? dateOfBirth;
  DateTime? _selectedDate;
  File? _avatar;
  String? _profileImagePath;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? '';
      lastName = prefs.getString('lastName') ?? '';
      email = prefs.getString('email') ?? '';
      phone = prefs.getString('phone') ?? '';
      address = prefs.getString('address') ?? '';
      gender = prefs.getString('gender') ?? '';
      dateOfBirth = prefs.getString('dateOfBirth') ?? '';

      _profileImagePath = prefs.getString('profileImagePath');
      if (_profileImagePath != null && _profileImagePath!.isNotEmpty) {
        _avatar = File(_profileImagePath!);
      }
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
    await prefs.setString('gender', gender);
    if (_selectedDate != null) {
      await prefs.setString('dateOfBirth', _selectedDate!.toIso8601String());
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _avatar = File(pickedFile.path);
          _profileImagePath = pickedFile.path;
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImagePath', pickedFile.path);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.deepPurple)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('email');
              await prefs.remove('password');
              await prefs.remove('profileImagePath');
              await CartHelper.clearCart();
              await clearOrders();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Splash()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _avatar != null
                        ? FileImage(_avatar!)
                        : _profileImagePath != null
                            ? FileImage(File(_profileImagePath!))
                            : null,
                    child: (_avatar == null && _profileImagePath == null)
                        ? const Icon(Icons.person, size: 50, color: Colors.deepPurple)
                        : null,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 20,
                    child: IconButton(
                      onPressed: pickImage,
                      icon: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoTile("Name", "$firstName $lastName", Icons.person),
            _buildInfoTile("Email", email, Icons.email),
            _buildInfoTile("Phone", phone, Icons.phone),
            _buildInfoTile("Address", address, Icons.location_on),
            _buildInfoTile("Gender", gender, Icons.person),
            _buildInfoTile("Date of Birth", dateOfBirth ?? 'Not set', Icons.calendar_today),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => logout(context),
              child: const Text("Logout?"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        subtitle: Text(value.isNotEmpty ? value : 'Not set'),
        leading: Icon(icon, color: Colors.deepPurple),
        trailing: label == "Date of Birth"
            ? IconButton(
                onPressed: () => _showDatePicker(context),
                icon: const Icon(Icons.calendar_today, color: Colors.deepPurple),
              )
            : IconButton(
                icon: const Icon(Icons.edit, color: Colors.deepPurple),
                onPressed: () => _editInfo(label),
              ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        dateOfBirth = _selectedDate!.toIso8601String();
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('dateOfBirth', dateOfBirth!);
    }
  }

  _editInfo(String label) {
    final _text = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $label"),
          content: TextField(
            controller: _text,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.edit, color: Colors.deepPurple),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                setState(() {
                  if (label == "Name") {
                    List<String> nameParts = _text.text.trim().split(" ");
                    firstName = nameParts.isNotEmpty ? nameParts[0] : '';
                    lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : '';
                  } else if (label == "Email") {
                    email = _text.text;
                  } else if (label == "Phone") {
                    phone = _text.text;
                  } else if (label == "Address") {
                    address = _text.text;
                  } else if (label == "Gender") {
                    gender = _text.text;
                  }
                });
                _saveUserData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
