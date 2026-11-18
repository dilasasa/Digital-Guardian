import 'package:digital_g/pages/connect_device_page.dart';
import 'package:digital_g/pages/dashboard_page.dart';
import 'package:digital_g/pages/login_page.dart';
import 'package:digital_g/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digital_g/myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized successfully!');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Function to check if the user is logged in
  Future<User?> _checkUserLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user; // User is logged in
    }
    return null; // No user is logged in
  }

  // Function to check if it's the first login
  Future<bool> _checkFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstLogin') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Guardian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
      routes: {
        '/': (context) => FutureBuilder<User?>(
          future: _checkUserLoginStatus(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (userSnapshot.hasError) {
              return const Center(child: Text('An error occurred'));
            } else if (userSnapshot.data != null) {
              // User is already logged in
              return FutureBuilder<bool>(
                future: _checkFirstLogin(),
                builder: (context, firstLoginSnapshot) {
                  if (firstLoginSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (firstLoginSnapshot.hasError) {
                    return const Center(child: Text('An error occurred'));
                  } else {
                    final isFirstLogin = firstLoginSnapshot.data ?? true;
                    if (isFirstLogin) {
                      // Navigate to ConnectDevicePage if it's the first login
                      return ConnectDevicePage(
                        onConnected: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isFirstLogin', false); // Mark as not first login
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        },
                      );
                    } else {
                      // Navigate to DashboardPage if it's not the first login
                      return const DashboardPage();
                    }
                  }
                },
              );
            } else {
              // No user is logged in, navigate to login page
              return const LoginPage();
            }
          },
        ),
        '/signup': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
        '/connect_device_page': (context) => ConnectDevicePage(
          onConnected: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isFirstLogin', false); // Mark as not first login
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
