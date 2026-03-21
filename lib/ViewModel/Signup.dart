import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';


class SignupViewModel
{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;





  // Signup Logic
  Future<String?> signup
      ({
    required String name,
    required String email,
    required String password,
    required String phonenumber,
    required String genderType,
    required String rooleType,

    required DateTime selectedDate,
    required DateTime birthdate,  String  ? specialization, String ? Hospital , String ? address , double? random
  }) async
  {
    try {
      // Create account
      UserCredential result =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = result.user!.uid;

      // Save user data
      await _firestore.collection("User").doc(uid).set
        (
          {
            "name": name,
            "email": email,
            "phonenumber": phonenumber,
            "genderType": genderType,
            "rooleType": rooleType,
            "random": Random().nextDouble(),
            "selectedDate": selectedDate,
            "birthdate" : Timestamp.fromDate(birthdate),
            "createdAt": Timestamp.now(),
            if(specialization!=null)
              "specialization": specialization ?? "",
              "random": Random().nextDouble(),
            if(Hospital!=null)
              "Hospital": Hospital ?? "",
            if(address!=null)
              "address": address ?? "",
          }
      );

      final specQuery = await _firestore
          .collection("specializations")
          .where("name", isEqualTo: specialization)
          .get();

      if (specQuery.docs.isEmpty)

      {
        await _firestore.collection("specializations").add({
          "name": specialization
        });
      }

      final hospitalQuery = await _firestore
          .collection("hospitals")
          .where("name", isEqualTo: Hospital)
          .get();

      if (hospitalQuery.docs.isEmpty)
      {
        await _firestore.collection("hospitals").add({
          "name": Hospital
        });
      }
      // Success
      return null;
    }
    catch (e) {
      return e.toString();
    }
  }

  String? validateemail(String email) {
    email = email.trim();
    if (email.isEmpty) {
      return "Email cannot be empty";
    }
    bool isValid = RegExp
      (
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    ).hasMatch(email);
    if (!isValid) {
      return "Please enter a valid email";
    }


    return null;
  }

  String? validateGoogleMapsLink(String? link)
  {
    if (link == null || link.isEmpty)
    {
      return "Google Maps link is required";
    }

    // Simple pattern check for Google Maps URLs
    bool isValid = RegExp(
        r'^(https:\/\/(www\.google\.com\/maps|maps\.app\.goo\.gl)\/.+)$'
    ).hasMatch(link);

    if (!isValid) {
      return "Please enter a valid Google Maps link";
    }

    return null;
  }


  String? validatepassword(String password) {
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password must contain at least one number";
    }

    // Must contain special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Password must contain at least one special character";
    }

    if (password.isEmpty) {
      return "Password cannot be empty";
    }

    if (password.length < 9) {
      return "Password must be at least 9 characters long ";
    }


    else {
      return null;
    }
  }

  String? validatephone(String phonenumber)
  {
    if (phonenumber.isEmpty)
    {
      return "Phone number cannot be empty";
    }

    if (!RegExp(r'^\d{10}$').hasMatch(phonenumber))
    {
      return "Invalid phone number";
    }

    else {
      return null;
    }
  }

  Future<User?> signInWithGoogle() async
  {
    try {
      final googleSignIn = GoogleSignIn.instance;

      // IMPORTANT: initialize first
      await googleSignIn.initialize();

      // Start interactive authentication
      final GoogleSignInAccount googleUser =
      await googleSignIn.authenticate();

      // Get ID token
      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);

      // Save to Firestore if new user
      final user = userCredential.user;

      if (user != null) {
        final doc =
        _firestore.collection("User").doc(user.uid);

        final snapshot = await doc.get();

        if (!snapshot.exists) {
          await doc.set({
            "name": user.displayName,
            "email": user.email,
            // default
            "createdAt": Timestamp.now(),
          });
        }
      }

      return user;

    } catch (e) {
      print("Google Sign-in error: $e");
      return null;
    }
  }
  Future<void> completeGoogleProfile
      (
      {
    required String uid,
    required String gender,
    required String role,
    required DateTime birthDate,
    required String phone,
        String ? specialization , String ? Hospital , String ? address
  }) async {
    await _firestore.collection("User").doc(uid).update({
      "genderType": gender,
      "rooleType": role,
      "birthdate" : Timestamp.fromDate(birthDate),
      "phone": phone,
      if(specialization!=null)
        "specialization": specialization ?? "",
      if(Hospital!=null)
        "Hospital": Hospital ?? "",
      if(address!=null)
        "Hospital address": address ?? "",
    });

    final specQuery = await _firestore
        .collection("specializations")
        .where("name", isEqualTo: specialization)
        .get();

    if (specQuery.docs.isEmpty)

    {
      await _firestore.collection("specializations").add({
        "name": specialization
      });
    }

    final hospitalQuery = await _firestore
        .collection("hospitals")
        .where("name", isEqualTo: Hospital)
        .get();

    if (hospitalQuery.docs.isEmpty)
    {
      await _firestore.collection("hospitals").add({
        "name": Hospital
      });
    }





  }


  Future<void> signOut() async
  {
    final googleSignIn = GoogleSignIn.instance;
    // Sign out from Google.
    await googleSignIn.signOut();

    // Sign out from Firebase.
    await _auth.signOut();
  }



}
