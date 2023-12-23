import 'package:ecart/firebase/authentication_services.dart';
import 'package:ecart/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../colors.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: color3,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text('ShoeLand,' , style: TextStyle(color: color2 , fontWeight: FontWeight.w500 , fontSize: 28),),
              Text(' Welcome\'s You...' , style: TextStyle( fontSize: 26),),
              SizedBox(height: 120),
              Text('"Find Your Perfect Pair at Shoe Land - Where Fashion Begins."' , textAlign: TextAlign.center,style: TextStyle(),),
              _buildAuthenticationSectionWidget(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildAuthenticationSectionWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 150),
            _buildActionButtonsWidget(),
            const SizedBox(height: 40 ),
            Row(
              children: [
                Expanded(child: Container( height: 1, color: color3,margin: EdgeInsets.only(right: 10),)),
                Text('Or else'),
                Expanded(child: Container( height: 1, color: color3,margin: EdgeInsets.only(left: 10),)),
              ],
            ),
            const SizedBox(height: 10 ),

            SignInButton(
              Buttons.google,
              onPressed: _handleGoogleSignIn,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtonsWidget() {
    return Column(
      children: <Widget>[
        _buildButton(
          backgroundColor: color2,
          label: 'Login',
          onPressed: _handleLogin,
        ),
        _buildButton(
          backgroundColor: color1,
          label: 'Sign up',
          onPressed: _handleSignUp,
        ),
      ],
    );
  }

  Widget _buildButton({required String label, required VoidCallback onPressed, Color? backgroundColor}) {
    return
      InkWell(
        onTap: () {
          onPressed();
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          width: 250,
          padding: EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: backgroundColor, // Background color
            borderRadius: BorderRadius.circular(25), // Rounded borders
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 16, // Text size
              ),
            ),
          ),
        ),);
  }
  void _handleGoogleSignIn() async {
    User? user = await AuthService().signInWithGoogle();
    if (user != null) {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(await userProvider.userService.getUserModel(user));
      Navigator.pushNamed(context, '/Home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign in with Google'),
      ));
    }
  }

  void _handleLogin() {
    // Implement your login functionality here
    Navigator.pushNamed(context, '/Home');
  }

  void _handleSignUp() {
    // Implement your sign-up functionality here
    Navigator.pushNamed(context, '/Home');
  }
}
