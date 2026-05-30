import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginViewModel
{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Signup Logic
  Future<String?> login
      (
      {

        required String email,
        required String password,
      }
      )
  async
  {
    try
    {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword
        (
          email: email,
          password: password
      );


      String uid = credential.user!.uid;

      // 2. Get user document from Firestore
      DocumentSnapshot userDoc =
      await _firestore.collection("User").doc(uid).get();

      if (!userDoc.exists)
      {
        return "User data not found";
      }

      // 3. Read role field
      String role = userDoc.get("rooleType"); // or "role" (match your DB field)

      // 4. Return role to UI
      return role;


      return null;

    }
    on FirebaseAuthException catch (e)
    {
      if (e.code == 'user-not-found')
      {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password')
      {
        print('Wrong password provided for that user.');
      }
      else
      {
        return e.message ?? 'Login failed';
      }


    }

    catch (e)
    {
      return e.toString();
    }
  }
  Future<void> logout() async
  {

    await FirebaseAuth.instance.signOut();

}

}
