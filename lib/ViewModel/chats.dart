import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';



class chat
{


  String get currentUserId => _auth.currentUser!.uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateChatId(String otherUserId)
  {
    final ids = [currentUserId, otherUserId]..sort();
    return ids.join("_");
  }

  // ✅ Create chat room if it doesn't exist
  Future<String> createOrGetChat(String otherUserId) async
  {
    final chatId = generateChatId(otherUserId);

    final chatDoc =
    _firestore.collection("chats").doc(chatId);

    final snapshot = await chatDoc.get();

    if (!snapshot.exists) {
      await chatDoc.set({
        "participants": [currentUserId, otherUserId],
        "lastMessage": "",
        "lastMessageTime": Timestamp.now(),
      });
    }

    return chatId;
  }

  // ✅ Send message
  Future<void> sendMessage
      (String chatId, String text,void clear) async
  {

    final messageRef = _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc();

    await messageRef.set(
        {
      "senderId": currentUserId,
      "text": text,
      "timestamp": Timestamp.now(),
          "messageid" : messageRef.id,
    });

    // Update last message in chat document
    await _firestore
        .collection("chats")
        .doc(chatId)
        .update({
      "lastMessage": text,
      "lastMessageTime": Timestamp.now(),
    });
  }

  // ✅ Stream messages (REAL TIME)
  Stream<List<Map<String, dynamic>>> streamMessages(String chatId)
  {
    return _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot)
    {
      return snapshot.docs

          .map((doc) => doc.data())
          .toList();

    });
  }

  // ✅ Stream chat list (like WhatsApp home)
  Stream<QuerySnapshot> streamUserChats()
  {
    return _firestore
        .collection("chats")
        .where("participants",
        arrayContains: currentUserId)
        .orderBy("lastMessageTime",
        descending: true)
        .snapshots();
  }




  Future<void> deleteMessage
      (String chatId, String messageId) async
  {
    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }




}