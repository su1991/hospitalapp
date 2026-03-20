import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationService
{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// 🔹 Initialize everything
  Future<void> init() async
  {
    // 1️⃣ Request permission (IMPORTANT for Android 13+ & iOS)
    NotificationSettings settings =
    await _firebaseMessaging.requestPermission();

    print("Permission: ${settings.authorizationStatus}");

    // 2️⃣ Get token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // 3️⃣ Save token to Firestore
    await _saveTokenToFirestore(token);

    // 4️⃣ Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async
    {
      print("New Token: $newToken");
      await _saveTokenToFirestore(newToken);
    });

    // 5️⃣ Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message)
    {
      print("Message received in foreground");


    });

    // 6️⃣ When app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message)
    {
      print("Notification clicked!");

      // You can navigate here if needed
    });
  }

  /// 🔹 Save token in Firestore
  Future<void> _saveTokenToFirestore(String? token) async
  {
    if (token == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("User")
        .doc(user.uid)
        .set({
      "fcmTokens": FieldValue.arrayUnion([token])
    },SetOptions(merge:true));


    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async
    {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        await FirebaseFirestore.instance
            .collection("User")
            .doc(userId)
            .set({
          "fcmTokens": FieldValue.arrayUnion([newToken])
        }, SetOptions(merge: true));
      }
    });
  }




}