import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class doctorhome
{


  Future<List<Map<String, dynamic>>> fetchtoday() async
  {
    final doctorId = FirebaseAuth.instance.currentUser!.uid;

    // 🔹 Get today's range
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await FirebaseFirestore.instance
        .collection("appointments")
        .where("doctorId", isEqualTo: doctorId)
        .where("day", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("day", isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    List<Map<String, dynamic>> todayappointmentsList = [];

    for (var doc in snapshot.docs) {
      final appointment = doc.data();

      final patientDoc = await FirebaseFirestore.instance
          .collection("User")
          .doc(appointment["patientId"])
          .get();

      todayappointmentsList.add({
        "patientName": patientDoc["name"],
        "patientId": patientDoc.id,
        "day": appointment["day"],
        "startTime": appointment["startTime"],
        "endTime": appointment["endTime"],
      });
    }

    return todayappointmentsList;
  }








}