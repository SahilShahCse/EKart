import 'package:ecart/navigator/navigator.dart';
import 'package:ecart/provider/cart_provider.dart';
import 'package:ecart/provider/product_provider.dart';
import 'package:ecart/provider/user_provider.dart';
import 'package:ecart/screens/authentication_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xffededed), // Change the status bar color to white
      statusBarIconBrightness: Brightness.dark, // Use dark icons for status bar
      systemNavigationBarColor: Color(0xffededed), // Change the navigation bar color to white
      systemNavigationBarIconBrightness: Brightness.dark, // Use dark icons for navigation bar
    ),
  );
  runApp(
    App(),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}
class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),

      ],
      child: MaterialApp(
        onGenerateRoute: NavigationController.getOnGenerateRoutes,
        home: AuthenticationScreen(),
      ),
    );
  }
}
