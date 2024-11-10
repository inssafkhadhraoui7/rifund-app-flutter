import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatBoxProvider extends ChangeNotifier {
  bool _isSendingMessage = false;
  bool get isSendingMessage => _isSendingMessage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String projectId = '';
  String communityId = '';
  String userId = '';

  List<Message> messages = [];
  TextEditingController messageController = TextEditingController();
  String communityName = '';
  String userName = '';
  String userImage = '';

  String get getUserId => userId;
  String get getProjectId => projectId;
  String get getCommunityId => communityId;

  void setup(String userId, String projectId, String communityId) {
    if (userId.isEmpty || projectId.isEmpty || communityId.isEmpty) {
      log('Error: userId, projectId, or communityId is empty.');
      throw Exception(
          'Required parameters (userId, projectId, communityId) are missing.');
    }

    this.userId = userId;
    this.projectId = projectId;
    this.communityId = communityId;
    notifyListeners();
    _loadMessages();
    _fetchCommunityName();
    _fetchUserName();
  }

  Future<void> _fetchCommunityName() async {
    DocumentSnapshot communityDoc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection('communities')
        .doc(communityId)
        .get();

    if (communityDoc.exists) {
      communityName = communityDoc['name'] ?? '';
      notifyListeners();
    }
  }

  Future<void> _fetchUserName() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      userName = currentUser.displayName ?? 'Unknown User';
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userName = userData['nom'] ?? 'Unknown User';
        String imageUrl = userData['image_user'] ?? '';
        userImage = await _fetchImageFromStorage(imageUrl);
      }

      notifyListeners();
    }
  }

  Future<String> _fetchImageFromStorage(String imageUrl) async {
    if (imageUrl.isNotEmpty) {
      return imageUrl;
    } else {
      return 'assets/images/avatar.png';
    }
  }

  Future<void> _loadMessages() async {
    _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection('communities')
        .doc(communityId)
        .collection('chat_messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      messages = snapshot.docs.map((doc) {
        return Message.fromFirestore(doc);
      }).toList();
      notifyListeners();
    });
  }

  Future<void> sendMessage(String message) async {
  if (message.isEmpty) {
    return;
  }

  if (userId.isEmpty || projectId.isEmpty || communityId.isEmpty) {
    log("Error: userId, projectId, or communityId is empty.");
    return;
  }

  _isSendingMessage = true;
  notifyListeners();

  try {
    // Send message to the chat
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection('communities')
        .doc(communityId)
        .collection('chat_messages')
        .add({
      'message': message,
      'isReceived': false,
      'userName': userName,
      'image_user': userImage,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Create a notification for the community
    await _firestore
    .collection('users')
    .doc(userId)
    .collection('notifications').add({
      'communityId': communityId,
      'message': '$userName a envoyé un message sur la communauté de $communityName ',
      'senderName': userName,
      'senderImage': userImage,
      'timestamp': FieldValue.serverTimestamp(),
    });

    messageController.clear();
  } catch (e) {
    log("Error sending message: $e");
  } finally {
    _isSendingMessage = false;
    notifyListeners();
  }
}

}

class Message {
  final String id;
  final String message;
  final bool isReceived;
  final String userName;
  final String userImage;
  final Timestamp timestamp;

  Message({
    required this.id,
    required this.message,
    required this.isReceived,
    required this.userName,
    required this.userImage,
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    return Message(
      id: doc.id,
      message: doc['message'] ?? '',
      isReceived: doc['isReceived'] ?? false,
      userName: doc['userName'] ?? 'Unknown User',
      userImage: doc['image_user'] ?? '',
      timestamp: doc['timestamp'] ?? Timestamp.fromDate(DateTime.now()),
    );
  }
}
