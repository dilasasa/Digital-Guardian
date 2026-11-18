// import 'package:flutter/material.dart';
// import 'package:digital_g/services/screen_time.dart';
//
// class ScreenTimeTracker extends StatefulWidget {
//   final Widget child;
//   final String userId;
//
//   const ScreenTimeTracker({
//     Key? key,
//     required this.child,
//     required this.userId,
//   }) : super(key: key);
//
//   @override
//   _ScreenTimeTrackerState createState() => _ScreenTimeTrackerState();
// }
//
// class _ScreenTimeTrackerState extends State<ScreenTimeTracker>
//     with WidgetsBindingObserver {
//   DateTime? _startTime;
//   final _screenTimeService = ScreenTimeService();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // App comes to foreground
//       _startTime = DateTime.now();
//     } else if (state == AppLifecycleState.paused) {
//       // App goes to background
//       if (_startTime != null) {
//         final duration = DateTime.now().difference(_startTime!).inMinutes;
//
//         _screenTimeService.saveScreenTime(
//           userId: widget.userId,
//           startTime: _startTime!,
//           endTime: DateTime.now(),
//           durationInMinutes: duration,
//         );
//         _startTime = null;
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }
