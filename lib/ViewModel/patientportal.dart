import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class patientportal
{
  Future<List<Map<String, dynamic>>> fetchFeaturedDoctors() async
  {

    double rand = Random().nextDouble();
    var snapshot = await FirebaseFirestore.instance
        .collection("User")
        .where("rooleType", isEqualTo: "doctor")
         .where("random", isGreaterThanOrEqualTo: rand)
        .limit(9)
        .get();
    if (snapshot.docs.isEmpty)
    {
      snapshot = await FirebaseFirestore.instance
          .collection("User")
          .where("rooleType", isEqualTo: "doctor")
          .where("random", isLessThan: rand)
          .limit(9)
          .get();
    }
    return snapshot.docs.map((doc)
    {
      return
        {
        "id": doc.id,
        "name": doc["name"],
        "specialization": doc["specialization"],
      };


    }).toList();


  }




}



