import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profiles
{
  String get currentUserId => _auth.currentUser!.uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> loadDoctordata() async
  {
    final String UserId = currentUserId;
    final doc = await FirebaseFirestore.instance
        .collection("User")
        .doc(UserId)
        .get();


    if (!doc.exists)
    {
      return [];
    }
    return
      [
      {
        "id": doc.id,
        ...doc.data()!,
      }
    ];
  }

  Future<void> modifyphone(String phone) async
  {

    final String UserId = currentUserId;
     User? user = FirebaseAuth.instance.currentUser!;
     final userid = user.uid;
     await user.updateDisplayName(phone);

    await FirebaseFirestore.instance
        .collection("User")
        .doc(UserId)
        .update({"phonenumber": phone ,});


  }

  Future<void> modifyname(String name) async
  {

    final String UserId = currentUserId;
    User? user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    await user.updateDisplayName(name);

    await FirebaseFirestore.instance
        .collection("User")
        .doc(UserId)
        .update({"name": name,});


  }



  Future<Map<String, dynamic>?> loadDoctorById(String doctorId) async {
    final doc = await FirebaseFirestore.instance
        .collection("User")
        .doc(doctorId)
        .get();

    if (!doc.exists) return null;

    return doc.data();
  }


}













