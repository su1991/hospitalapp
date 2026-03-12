import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    required DateTime birthdate,  String  ? specialization,
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
            "selectedDate": selectedDate,
            "birthdate" : Timestamp.fromDate(birthdate),
            "createdAt": Timestamp.now(),
            if(specialization!=null)
               "specialization" : specialization

          }
      );

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
  Future<void> completeGoogleProfile(
      {
    required String uid,
    required String gender,
    required String role,
    required DateTime birthDate,
    required String phone,
        String ? specialziation
  }) async {
    await _firestore.collection("User").doc(uid).update({
      "genderType": gender,
      "rooleType": role,
      "birthDate": birthDate,
      "phone": phone,
      if(specialziation!=null)
        "specialziation": specialziation
    });
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
