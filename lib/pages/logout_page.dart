import 'package:flutter/material.dart';
import 'package:digital_g/pages/about_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LogoutPage extends StatelessWidget {
  const LogoutPage({Key? key}) : super(key: key);


  Future<void> logout(BuildContext context) async {
    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Remove the 'isFirstLogin' flag from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isFirstLogin');

    // Navigate to the Login page
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About Us Navigation Button
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text(
                "About Us",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/about_page');
              },
            ),

            const Divider(), // Divider for better separation

            // Connected Device Details Button
            ListTile(
              leading: const Icon(Icons.devices, color: Colors.blue),
              title: const Text(
                "Connected Device Details",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/connected_device_details');
              },
            ),

            const Divider(), // Divider for better separation

            // My Account Navigation Button
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.blue),
              title: const Text(
                "My Account",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/my_account');
              },
            ),

            const Spacer(), // Pushes the Logout button to the bottom

            // Logout Button
            Center(
              child: SizedBox(
                width: 200, // Fixed width for the Logout button
                child: ElevatedButton(
                  onPressed: () {
                    // Handle logout logic
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Pretty blue color
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
