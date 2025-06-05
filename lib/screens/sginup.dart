import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testproject/screens/home.dart';
import 'package:testproject/screens/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  bool _isLoading = false;

  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String address = '';
  String password = '';
  String confirmPassword = '';
  String? _selectedGender = 'Male';
  DateTime? _selectedDate;

  File? _avatar;
  String? _profileImagePath;
// Future<void> pickImage() async {
//   try {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//     );

//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _avatar = File(result.files.single.path!);
//         _profileImagePath = result.files.single.path!;
//       });
//     }
//   } catch (e) {
//     _showErrorSnackBar('Failed to pick image: ${e.toString()}');
//   }
// }

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
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: ${e.toString()}');
    }
  }


  Future<void> _selectDate(BuildContext context) async {
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? '';
      lastName = prefs.getString('lastName') ?? '';
      email = prefs.getString('email') ?? '';
      phone = prefs.getString('phone') ?? '';
      address = prefs.getString('address') ?? '';
      password = prefs.getString('password') ?? '';
      _selectedGender = prefs.getString('gender');
      if (_selectedGender != 'Male' && _selectedGender != 'Female') {
        _selectedGender = 'Male';
      }
    });
  }

  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill all required fields correctly');
      return;
    }

    if (password != confirmPassword) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    if (_selectedGender == null) {
      _showErrorSnackBar('Please select your gender');
      return;
    }

    if (_selectedDate == null) {
      _showErrorSnackBar('Please select your date of birth');
      return;
    }

final prefs = await SharedPreferences.getInstance();

  
  final storedEmail = prefs.getString('email');
  if (storedEmail != null && storedEmail == email) {
    _showErrorSnackBar('This email is already registered.');
    return;
  }
    setState(() {
      _isLoading = true;
    });

    try {
      await prefs.setString('firstName', firstName);
      await prefs.setString('lastName', lastName);
      await prefs.setString('email', email);
      await prefs.setString('phone', phone);
      await prefs.setString('address', address);
      await prefs.setString('password', password);
      await prefs.setString('gender', _selectedGender!);
      await prefs.setString('dateOfBirth', _selectedDate!.toIso8601String());

      _loadUsername();
      if (_profileImagePath != null) {
        await prefs.setString('profileImagePath', _profileImagePath!);
      }
      _showSuccessSnackBar('Registration successful!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MyHome()),
      );
    } catch (e) {
      _showErrorSnackBar('Error saving data: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,

      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  (_avatar != null && _avatar!.existsSync())
                                  ? FileImage(_avatar!)
                                  : null,
                              child: (_avatar == null || !_avatar!.existsSync())
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.deepPurple,
                                    )
                                  : null,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              radius: 20,
                              child: IconButton(
                                onPressed: pickImage,
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      formField(
                        name: "Enter First Name",
                        icon: Icons.person,
                        onChanged: (val) => setState(() => firstName = val),
                        abscureText: false,
                      ),
                      formField(
                        name: "Enter Last Name",
                        icon: Icons.person,
                        onChanged: (val) => setState(() => lastName = val),
                        abscureText: false,
                      ),
                      formField(
                        name: "Enter Your Phone",
                        icon: Icons.phone_android,
                        onChanged: (val) => setState(() => phone = val),
                        abscureText: false,
                      ),
                      formField(
                        name: "Enter Your Email",
                        icon: Icons.email,
                        onChanged: (val) => setState(() => email = val),
                        abscureText: false,
                      ),
                      formField(
                        name: "Enter Your Address",
                        icon: Icons.home,
                        onChanged: (val) => setState(() => address = val),
                        abscureText: false,
                      ),
                      formField(
                        name: "Enter Your Password",
                        icon: Icons.lock,
                        onChanged: (val) => setState(() => password = val),
                        abscureText: true,
                      ),
                      formField(
                        name: "Confirm Password",
                        icon: Icons.lock,
                        onChanged: (val) =>
                            setState(() => confirmPassword = val),
                        abscureText: true,
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InputDecorator(
                          decoration: buildInputDecoration(
                            "Gender",
                            Icons.person_outline,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedGender,
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('Select your gender'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Male',
                                  child: Text('Male', style: TextStyle(color: Colors.deepPurple),),
                                ),
                                DropdownMenuItem(
                                  value: 'Female',
                                  child: Text('Female', style: TextStyle(color: Colors.deepPurple)),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: InputDecorator(
                            decoration: buildInputDecoration(
                              'Date of Birth',
                              Icons.calendar_today,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDate == null
                                      ? 'Select your date of birth'
                                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                  style: TextStyle(
                                    color: _selectedDate == null
                                        ? Colors.grey[600]
                                        : Colors.black,
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveUserData,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Register Now",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ), 
                      const SizedBox(height: 10),                   
                         LoginRedirect(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  InputDecoration buildInputDecoration(String title, IconData icon) {
    return InputDecoration(
      labelText: title,
      labelStyle: const TextStyle(
        color: Colors.deepPurple,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      prefixIcon: Icon(icon, color: Colors.deepPurple),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}

Widget formField({
  required String name,
  required IconData icon,
  required Function(String) onChanged,
  required bool abscureText,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      obscureText: abscureText,
      keyboardType: name == "Enter Your Phone"
          ? TextInputType.phone
          : name == "Enter Your Email"
          ? TextInputType.emailAddress
          : name == "Enter Your Address"
          ? TextInputType.multiline
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: name,
        labelStyle: const TextStyle(
          color: Colors.deepPurple,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      onChanged: onChanged,
      style: const TextStyle(color: Colors.deepPurple),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $name';
        }
        switch (name) {
          case "Enter Your Name":
            if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
              return 'Please enter a valid name';
            }
            break;
          case "Enter Your Email":
            if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
              return 'Please enter a valid email';
            }
            break;
          case "Enter Your Password":
            if (!RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
            ).hasMatch(value)) {
              return 'Please enter a valid password';
            }
            break;
          case "Enter Your Phone":
            if (!RegExp(r"^[010|011|012|015][0-9]{10}$").hasMatch(value)) {
              return 'Please enter a valid phone number';
            }
            break;
        }
        return null;
      },
    ),
  );
}

class LoginRedirect extends StatelessWidget {
  const LoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: "Already have an account? ",
            style: const TextStyle(color: Colors.grey, fontSize: 16),
            children: [
              TextSpan(
                text: "Login",
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

