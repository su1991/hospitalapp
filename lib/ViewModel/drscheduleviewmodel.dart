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




}