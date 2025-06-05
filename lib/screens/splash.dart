import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:testproject/screens/onboarding.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final List<PageViewModel> pages = [
    PageViewModel(
      title: "Shop online",
      body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      image: Image.network(
        'https://img.freepik.com/free-vector/online-shopping-concept-landing-page_52683-20156.jpg?semt=ais_items_boosted&w=740',
        height: 500,
      ),
      decoration: PageDecoration(
        imageFlex: 3,
        bodyFlex: 1,
        titleTextStyle: TextStyle(
          color: Color(0xFF6B4E9E),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyTextStyle: TextStyle(color: Colors.grey, fontSize: 16),
        pageColor: Colors.white,
      ),
    ),
    PageViewModel(
      title: "Choose a payment method",
      body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      image: Image.network(
        'https://img.freepik.com/free-vector/nfc-connection-abstract-concept-illustration-bank-connection-nfc-communication-contactless-card-payment-method-banking-technology-financial-transaction-paying-app_335657-274.jpg?semt=ais_hybrid&w=740',
        height: 500,
      ),
      decoration: PageDecoration(
        imageFlex: 3,
        bodyFlex: 1,
        titleTextStyle: TextStyle(
          color: Color(0xFF6B4E9E),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyTextStyle: TextStyle(color: Colors.grey, fontSize: 16),
        pageColor: Colors.white,
      ),
    ),
    PageViewModel(
      title: "Get your order",
      body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      image: Image.network(
        'https://static.vecteezy.com/system/resources/previews/033/126/722/non_2x/3d-purple-illustration-icon-of-smartphone-for-online-shopping-store-bill-with-loudspeaker-and-review-stars-free-png.png',
        height: 500,
      ),
      decoration: PageDecoration(
        imageFlex: 3,
        bodyFlex: 1,
        titleTextStyle: TextStyle(
          color: Color(0xFF6B4E9E),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyTextStyle: TextStyle(color: Colors.grey, fontSize: 16),
        pageColor: Colors.white,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: pages,
        onDone: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OnBoarding()),
          );
        },
        showSkipButton: true,
        skip: Text("Skip", style: TextStyle(color: Color(0xFF6B4E9E))),
        next: Text("Next", style: TextStyle(color: Color(0xFF6B4E9E))),
        done: Text("Start", style: TextStyle(color: Color(0xFF6B4E9E))),
        dotsDecorator: DotsDecorator(
          activeColor: Color(0xFF6B4E9E),
          size: Size(10, 10),
          activeSize: Size(20, 10),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
