import 'package:flutter/material.dart';
import 'package:testproject/screens/login.dart';
import 'package:testproject/screens/sginup.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
           
            children: [
              Image.asset(
                'images/Capture.PNG',
                height: MediaQuery.of(context).size.height * 0.4
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()));
                      },
                      child: const Text("Create an acount")),
                ),
              ),
              SizedBox(
                  width: 200,
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text("Login")))
            ],
          ),
        ),
      ),
    );
  }
}
