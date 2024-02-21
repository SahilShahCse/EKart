import 'package:ecart/firebase/authentication_services.dart';
import 'package:ecart/provider/user_provider.dart';
import 'package:ecart/screens/profile/settings_page.dart';
import 'package:ecart/screens/profile/subscription_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context,listen: false);

    if(userProvider.user == null){
      return Scaffold(
        body: Center(child: Text('Login First'),),
      );
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Profile',style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)),
            CircleAvatar(
              radius: 100,
              // backgroundImage: NetworkImage(userProvider.user!.profileImg),
            ),
            SizedBox(height: 20),
            Text(
              userProvider.user!.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              userProvider.user!.email,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Subscription'),
              leading: Icon(Icons.subscriptions),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubscriptionPage()),
                );
              },
            ),
            ListTile(
              title: Text('Logout' , style: TextStyle(color: Colors.red),),
              leading: Icon(Icons.logout , color: Colors.red,),
              onTap: () {
                Provider.of<UserProvider>(context,listen: false).setUser(null);
               AuthService().signOut().then((value) =>   Navigator.popUntil(context, ModalRoute.withName('/Authentication')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
