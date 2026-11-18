import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'logout_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  String? _deviceName;
  int? _screenTime;
  List<String> _blockedApps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeviceData();
  }

  Future<void> _loadDeviceData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not authenticated.");

      // Fetch connected device ID
      final userRef = _database.child('users').child(userId);
      final deviceLinkedSnapshot = await userRef.child('deviceLinked').get();
      final deviceId = deviceLinkedSnapshot.value as String?;

      if (deviceId == null) throw Exception("No connected device found.");

      // Fetch device data
      final deviceRef = _database.child('devices').child(deviceId);
      final deviceSnapshot = await deviceRef.get();

      if (!deviceSnapshot.exists) throw Exception("Device data not found.");

      final deviceData = deviceSnapshot.value as Map;

      setState(() {
        _deviceName = deviceData['metadata']['deviceName'];
        _screenTime = deviceData['screentime']['today'] as int?;
        _blockedApps = List<String>.from(deviceData['appblock']['blockedApps']);
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(77.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 13.0, left: 5.0, right: 5.0),
                child: Image.asset(
                  'assets/images/dg_logo.png',
                  height: 40,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 17.5), // Adjust padding above the text
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    const Text(
                      'digital guardian', // Main title text
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Title color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 17.0), // Adjust the padding as needed
              child: IconButton(
                icon: const Icon(Icons.menu), // Menu icon
                color: Colors.black45, // Set the icon color here
                onPressed: () {
                  // Navigate to the LogoutPage when the icon is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogoutPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Name: ${_deviceName ?? "N/A"}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Today\'s Screen Time: ${_screenTime ?? 0} minutes',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Blocked Apps:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ..._blockedApps.map((app) => Text('- $app')).toList(),
          ],
        ),
      ),
    );
  }
}