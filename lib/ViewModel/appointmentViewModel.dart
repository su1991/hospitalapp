import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'notifications_service.dart';
class appointmentViewModel
{
  Future<List<Map<String, dynamic>>> fetchDoctors() async
  {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("User")
          .where("rooleType", isEqualTo: "doctor")
          .get();

      final List<Map<String, dynamic>> loadedDoctors = [];

      for (var doc in snapshot.docs) {
        loadedDoctors.add({
          "id": doc.id,
          "name": doc["name"],
        });
      }

      return loadedDoctors;
    } catch (e) {
      print("Error fetching doctors: $e");
      return []; // ✅ REQUIRED
    }
  }


  Future<List<Map<String, dynamic>>> fetchDoctorSlots(
      {
    required String doctorId,
  }) async {
    final firestore = FirebaseFirestore.instance;

    // 1️⃣ Get all slots for this doctor
    final slotsSnapshot = await firestore
        .collection("slots")
        .where("doctorId", isEqualTo: doctorId)
        .get();

    // 2️⃣ Get all appointments for this doctor
    final appointmentsSnapshot = await firestore
        .collection("appointments")
        .where("doctorId", isEqualTo: doctorId)
        .get();

    // 3️⃣ Collect booked slotIds
    final bookedSlotIds = appointmentsSnapshot.docs
        .map((doc) => doc["slotId"] as String)
        .toSet(); // using Set for fast lookup

    // 4️⃣ Map slots and compute isBooked dynamically
    return slotsSnapshot.docs.map((doc) {
      final slotId = doc.id;

      return {
        "id": slotId,
        "day": doc["day"],
        "startTime": doc["startTime"],
        "endTime": doc["endTime"],
        "isBooked": bookedSlotIds.contains(slotId),
      };
    }).toList();
  }

  Future<void> saveAppointments(
      {
    required String doctorId,
    required String patientId,
    required String slotId,
  }) async {


    final firestore = FirebaseFirestore.instance;

    await firestore.runTransaction((transaction) async
    {

      // 1️⃣ Check if appointment already exists for this slot
      final existing = await firestore
          .collection("appointments")
          .where("slotId", isEqualTo: slotId)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception("Slot already booked");
      }
      final slotRef = firestore.collection("slots").doc(slotId);
      final slotSnap = await transaction.get(slotRef);
      final slotData = slotSnap.data()!;

      // 2️⃣ Create appointment
      final newAppointmentRef =
      firestore.collection("appointments").doc();

      transaction.set(newAppointmentRef, {
        "doctorId": doctorId,
        "patientId": patientId,
        "slotId": slotId,
        "createdAt": FieldValue.serverTimestamp(),
        "day": slotData["day"],
        "startTime": slotData["startTime"],
        "endTime": slotData["endTime"],


      });
    });


  }


  Stream<Map<String, dynamic>?> loadNextAppointment()
  {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection("appointments")
        .where("patientId", isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async
    {
      if (snapshot.docs.isEmpty) return null;

      final appointment = snapshot.docs.first.data();

      final doctorDoc = await FirebaseFirestore.instance
          .collection("User")
          .doc(appointment["doctorId"])
          .get();

      final slotDoc = await FirebaseFirestore.instance
          .collection("slots")
          .doc(appointment["slotId"])
          .get();

      return {
        "doctorName": doctorDoc.data()?["name"] ?? "Unknown",
        "day": slotDoc.data()?["day"] ?? "",
        "startTime": slotDoc.data()?["startTime"] ?? "",
        "endTime": slotDoc.data()?["endTime"] ?? "",
        "doctorId": doctorDoc.id
      };
    });
  }

  Future<String?> fetchPatientName() async
  {
    try
    {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance
          .collection("User")
          .doc(userId)
          .get();

      if (!doc.exists) return null;

      return doc["name"];
    } catch (e)
    {
      print("Error fetching name: $e");
      return null;
    }
  }

  Future<String?> fetchoppositeName(String userId) async
  {
    try
    {


      final doc = await FirebaseFirestore.instance
          .collection("User")
          .doc(userId)
          .get();

      if (!doc.exists) return null;

      return doc["name"];
    } catch (e)
    {
      print("Error fetching name: $e");
      return null;
    }
  }


  Stream<List<Map<String, dynamic>>> fetchSavedAppointments()
  {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection("appointments")
        .where("patientId", isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {

      List<Map<String, dynamic>> appointments = [];

      for (var doc in snapshot.docs) {

        final appointmentData = doc.data();
        final appointmentId = doc.id;

        final doctorId = appointmentData["doctorId"];
        final slotId = appointmentData["slotId"];

        final doctorDoc = await FirebaseFirestore.instance
            .collection("User")
            .doc(doctorId)
            .get();

        final slotDoc = await FirebaseFirestore.instance
            .collection("slots")
            .doc(slotId)
            .get();

        appointments.add({
          "appointmentId": appointmentId,
          "doctorName": doctorDoc.data()?["name"] ?? "Unknown",
          "day": slotDoc.data()?["day"] ?? "",
          "startTime": slotDoc.data()?["startTime"] ?? "",
          "endTime": slotDoc.data()?["endTime"] ?? "",
          "doctorId": doctorId,
          "slotId": slotId,
        });
      }

      return appointments;
    });
  }


  Future<void> cancelAppointment(String appointmentId) async
  {
    await FirebaseFirestore.instance
        .collection("appointments")
        .doc(appointmentId)
        .delete();
  }


  Future<List<Map<String, dynamic>>> fetchSpecializations() async
  {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("specializations")

          .get();

      final List<Map<String, dynamic>> loadedspecialization = [];

      for (var doc in snapshot.docs) {
        loadedspecialization.add({

          "specialization": doc["name"],
        });
      }

      return loadedspecialization;
    } catch (e) {
      print("Error fetching specialzaiton: $e");
      return []; // ✅ REQUIRED
    }
  }




  Future<List<Map<String, dynamic>>> fetchhospitals() async
  {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("hospitals")

          .get();

      final List<Map<String, dynamic>> loadedhospital = [];

      for (var doc in snapshot.docs) {
        loadedhospital.add({

          "hospital": doc["name"],
        });
      }

      return loadedhospital;
    } catch (e) {
      print("Error fetching specialzaiton: $e");
      return []; // ✅ REQUIRED
    }
  }


  Future<List<Map<String,dynamic>>> fetchSpecializationsByHospital(String hospital) async
  {

    final snapshot = await FirebaseFirestore.instance
        .collection("User")
        .where("rooleType", isEqualTo: "doctor")
        .where("Hospital", isEqualTo: hospital)
        .get();

    final List<Map<String,dynamic>> result = [];

    for (var doc in snapshot.docs)
    {
      result.add({
        "specialization": doc["specialization"]
      });
    }

    return result;
  }

  Future<List<Map<String,dynamic>>> fetchDoctorsByFilter(
      String hospital,
      String specialization) async {

    final snapshot = await FirebaseFirestore.instance
        .collection("User")
        .where("rooleType", isEqualTo: "doctor")
        .where("Hospital", isEqualTo: hospital)
        .where("specialization", isEqualTo: specialization)
        .get();

    final List<Map<String,dynamic>> result = [];

    for (var doc in snapshot.docs) {
      result.add({
        "id": doc.id,
        "name": doc["name"]
      });
    }

    return result;
  }


}