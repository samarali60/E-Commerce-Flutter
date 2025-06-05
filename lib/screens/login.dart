import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testproject/screens/home.dart';
import 'package:testproject/screens/home_screen.dart';
import 'package:testproject/screens/sginup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  Future<void> _login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    String enteredEmail = _emailController.text.trim();
    String enteredPassword = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      if (enteredEmail == savedEmail && enteredPassword == savedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful"), 
          backgroundColor: Colors.green,
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (_)=> const MyHome()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect email or password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration:buildInputDecoration("Email", Icons.email),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: buildInputDecoration("Password", Icons.lock),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                                  "Login",
                                  style: TextStyle(fontSize: 16),
                                ),
                  ),
                ),
              ),
              SignupRedirect()
            ],
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
      suffixIcon: title == "Password" ?IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.deepPurple,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ): null,
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

class SignupRedirect extends StatelessWidget {
  const SignupRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: const TextStyle(color: Colors.grey, fontSize: 16),
            children: [
              TextSpan(
                text: "Sign up",
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Signup()),
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
