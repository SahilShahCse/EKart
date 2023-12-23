import 'package:ecart/colors.dart';
import 'package:flutter/material.dart';
import 'package:ecart/screens/checkout_screen.dart';
import 'package:ecart/screens/profile_screen.dart';
import 'package:ecart/screens/view_products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currIndex = 0;

  final List<Widget> _pages = [
    ViewProductsScreen(),
    CheckoutScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int newIndex) {
    setState(() {
      _currIndex = newIndex;
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _getBottomNavigationBar(),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _pages,
        ),
      ),
    );
  }

  Widget _getBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: color2,
      currentIndex: _currIndex,
      onTap: _onNavItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Checkout',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
