import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Drtimeviewmodel
{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addAvailability({
    required String day,
    required String startTime,
    required String endTime,
  }) async {
    try {

      // Get current logged in doctor
      final User? user = _auth.currentUser;

      if (user == null) {
        return "User not logged in";
      }

      await _firestore.collection("slots").add(
          {
        "doctorId": user.uid,
        "day": day,
        "startTime": startTime,
        "endTime": endTime,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return null; // success

    } catch (e) {
      return e.toString();
    }
  }
}
