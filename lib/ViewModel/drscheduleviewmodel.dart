import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class drschedule
{



  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> loadDoctorAppointments() async
  {
    final doctorId = FirebaseAuth.instance.currentUser!.uid;
    print("Current Doctor ID: $doctorId");


    final snapshot = await FirebaseFirestore.instance
        .collection("appointments")
        .where("doctorId", isEqualTo: doctorId)
        .get();
    print("Appointments found: ${snapshot.docs.length}");

    if (snapshot.docs.isEmpty)
    {
      return [];
    }

    List<Map<String, dynamic>> appointmentsList = [];

    for (var doc in snapshot.docs)
    {
      final appointment = doc.data();

      final patientDoc = await FirebaseFirestore.instance
          .collection("User")
          .doc(appointment["patientId"])
          .get();

      final slotDoc = await FirebaseFirestore.instance
          .collection("slots")
          .doc(appointment["slotId"])
          .get();

      appointmentsList.add({
        "patientName": patientDoc["name"],
        "patientId" :  patientDoc.id,
        "day": slotDoc["day"],
        "startTime": slotDoc["startTime"],
        "endTime": slotDoc["endTime"],
        "createdAt": appointment["createdAt"],
      });
    }

    return appointmentsList;
  }


  Future<List<Map<String, dynamic>>> fetchtodayorlater() async
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
        .get();

    List<Map<String, dynamic>> todayappointmentsList = [];

    for (var doc in snapshot.docs) {
      final appointment = doc.data();

      final patientDoc = await FirebaseFirestore.instance
          .collection("User")
          .doc(appointment["patientId"])
          .get();
      final slotDoc = await FirebaseFirestore.instance
          .collection("slots")
          .doc(appointment["slotId"])
          .get();

      todayappointmentsList.add({
        "patientName": patientDoc["name"],
        "patientId": patientDoc.id,
        "day": slotDoc["day"],
        "startTime": slotDoc["startTime"],
        "endTime": slotDoc["endTime"],
        "createdAt": appointment["createdAt"],
      });
    }

    return todayappointmentsList;
  }



}