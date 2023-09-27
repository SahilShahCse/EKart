import 'package:ecart/firebase/authentication_services.dart';
import 'package:ecart/firebase/user_services.dart';
import 'package:ecart/models/user_model.dart';
import 'package:ecart/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';


import '../firebase/product_service.dart';
import '../provider/product_provider.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildImageSection(),
          _buildAuthenticationSection(),
        ],
      ),
    );
  }

  // Image section
  Widget _buildImageSection() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 4 / 6,
        child: Image.network(
          'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/awjogtdnqxniqqk0wpgf/air-max-270-shoes-2V5C4p.png',
        ),
      ),
    );
  }

  // Authentication section
  Widget _buildAuthenticationSection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
            _buildWelcomeText(), // Welcome text
            const SizedBox(
              height: 30,
            ),
            _buildActionButtons(),
            const SizedBox(height: 10),
            SignInButton(
              Buttons.google,
              onPressed: () async {
                User? user = await AuthService().signInWithGoogle();
                if (user != null) {
                  UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
                  userProvider.setUser(await userProvider.userService.getUserModel(user));
                  Navigator.pushNamed(context, '/Home');
                } else {
                  print('error : ${user}');
                }
              },
            ), // Google Sign-In button
          ],
        ),
      ),
    );
  }

  // Welcome text
  Widget _buildWelcomeText() {
    return Text(
      'Welcome to EKart...',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: <Widget>[
        _buildElevatedButton(
          backgroundColor: Color(0xff6d8df7),
          label: 'Login',
          onPressed: () async {
            Navigator.pushNamed(context, '/Home');
          },
        ),
        _buildElevatedButton(
          backgroundColor: Color(0xffff8b8b),
          label: 'Sign up',
          onPressed: () async {
            Navigator.pushNamed(context, '/Home');
          },
        ),
      ],
    );
  }

  Widget _buildElevatedButton({required String label, required VoidCallback onPressed, Color? backgroundColor}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
