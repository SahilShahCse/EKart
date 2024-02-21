import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Appearance'),
            _buildDarkModeSwitch(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDarkModeSwitch() {
    return Row(
      children: [
        Text(
          'Dark Mode',
          style: TextStyle(fontSize: 16),
        ),
        Spacer(),
        Switch(
          value: _darkModeEnabled,
          onChanged: _toggleDarkMode,
        ),
      ],
    );
  }

  void _logout() {
    // Implement logout functionality here
    // For example, you can navigate to the login page and clear user data.
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkModeEnabled = value;
      // Implement code to switch the app's theme to dark mode
      // based on the value of _darkModeEnabled.
    });
  }
}
