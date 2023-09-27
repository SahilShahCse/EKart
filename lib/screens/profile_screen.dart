import 'package:ecart/models/product_model.dart';
import 'package:ecart/models/user_model.dart';
import 'package:ecart/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: (Provider.of<UserProvider>(context,listen: false).user!= null)?SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: _buildProfileContent(),
        ),
      ) : Center(child: Text('Login To Use This Page!'),)
    );
  }

  Widget _buildProfileContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildProfilePicture(),
        SizedBox(height: 50),
        _buildUserId(),
        SizedBox(height: 50),
        _buildTextFields(),
        SizedBox(height: 50),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.teal,
      ),
    );
  }

  Widget _buildUserId() {
    return const Text(
      'User ID',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextFields() {
    UserModel? user = Provider.of<UserProvider>(context,listen: false).user;
    print('${user}');

    name.text = (user!.name.isEmpty)? '' : user!.name;
    password.text = (user!.name.isEmpty)? '' : user!.password;

    return Column(
      children: <Widget>[
        _buildTextField(labelText: 'Name' , isEnabled: true, controller: name) ,
        _buildTextField(labelText: user!.email, controller: email , isEnabled: false),
        _buildTextField(labelText:'Password' , obscureText: true , controller: password ,isEnabled: true),
      ],
    );
  }

  Widget _buildTextField({required String labelText, required bool isEnabled,required TextEditingController controller, bool obscureText = false}) {
    return TextField(
      enabled: isEnabled,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      obscureText: obscureText,
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: <Widget>[
        _buildElevatedButton(
          backgroundColor: Color(0xff6d8df7),
          label: 'Save Info',
          onPressed: () {

            UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
            userProvider.user!.password = password.text.trim().isNotEmpty? password.text.trim() : userProvider.user!.password;
            print(password.text);
            userProvider.user!.name = name.text.trim().isNotEmpty? name.text.trim() : userProvider.user!.name;
            userProvider.userService.updateUser(userProvider.user as UserModel);

            setState(() {});
          },
        ),
        _buildElevatedButton(

          backgroundColor: Color(0xffff8b8b),
          label: 'Premium',
          onPressed: () {
            // Implement your "Premium" button functionality here
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
