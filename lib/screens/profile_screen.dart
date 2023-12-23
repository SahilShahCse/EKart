import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import '../provider/user_provider.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (Provider.of<UserProvider>(context, listen: false).user != null)
          ? SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: _buildProfileContent(),
                ),
              ),
            )
          : Center(
              child: Text('Login To Use This Page!'),
            ),
    );
  }

  Widget _buildProfileContent() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 100,
        ),
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
    return Text(
      'user-id : ${Provider.of<UserProvider>(context, listen: false).user!.id}',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextFields() {
    UserModel? user = Provider.of<UserProvider>(context, listen: false).user;
    name.text = user!.name.isNotEmpty ? user.name : '';
    password.text = user.password.isNotEmpty ? user.password : '';

    return Column(
      children: <Widget>[
        _buildTextField(labelText: 'Name', isEnabled: true, controller: name),
        _buildTextField(labelText: 'Email : ${user.email}', controller: email, isEnabled: false),
        _buildTextField(labelText: 'Password', obscureText: true, controller: password, isEnabled: true),
      ],
    );
  }

  Widget _buildTextField({required String labelText, required bool isEnabled, required TextEditingController controller, bool obscureText = false}) {
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
        _buildButton(
          backgroundColor: color1,
          label: 'Save Info',
          onPressed: _saveUserInfo,
        ),
        _buildButton(
          backgroundColor: color2,
          label: 'Premium',
          onPressed: _handlePremium,
        ),
      ],
    );
  }

  void _saveUserInfo() {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.user!.password = password.text.trim().isNotEmpty ? password.text.trim() : userProvider.user!.password;
    userProvider.user!.name = name.text.trim().isNotEmpty ? name.text.trim() : userProvider.user!.name;
    userProvider.userService.updateUser(userProvider.user as UserModel);
    setState(() {});
  }

  void _handlePremium() {
    // Implement your "Premium" button functionality here
  }

  Widget _buildButton({required String label, required VoidCallback onPressed, Color? backgroundColor}) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: 250,
        margin: EdgeInsets.only(bottom: 10),
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
      ),
    );
  }
}
