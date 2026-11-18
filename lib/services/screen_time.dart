// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ScreenTimeService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> saveScreenTime({
//     required String userId,
//     required DateTime startTime,
//     required DateTime endTime,
//     required int durationInMinutes,
//   }) async {
//     await _firestore.collection('screen_time').add({
//       'userId': userId,
//       'startTime': startTime.toIso8601String(),
//       'endTime': endTime.toIso8601String(),
//       'durationInMinutes': durationInMinutes,
//     });
//   }
// }
