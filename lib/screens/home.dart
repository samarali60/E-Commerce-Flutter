import 'package:flutter/material.dart';
import 'package:testproject/screens/cart_page.dart';
import 'package:testproject/screens/home_screen.dart';
import 'package:testproject/screens/order_page.dart';
import 'package:testproject/screens/profile.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
    int _selectedIndex = 0;


  final List<Widget> _screens = [
     HomeScreen(),
      OrdersPage(),
     CartPage(),
     ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_screens[_selectedIndex],
     bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped, 
        items: [
           BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "home",
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Orders",
          ),
         
            BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}