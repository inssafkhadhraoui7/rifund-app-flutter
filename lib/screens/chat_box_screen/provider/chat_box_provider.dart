import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_box_model.dart';

class ChatBoxProvider extends ChangeNotifier {
  bool _isSendingMessage = false;

  bool get isSendingMessage => _isSendingMessage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String projectId;
  final String communityId;
  final String userId;

  List<Message> messages = [];
  TextEditingController messageController = TextEditingController();
  String communityName = '';
  String userName = '';
  String userImage = ''; // Add userImage field

  ChatBoxProvider(this.projectId, this.communityId)
      : userId = FirebaseAuth.instance.currentUser?.uid ?? '' {
    print("ChatBoxProvider initialized with userId: $userId, projectId: $projectId, communityId: $communityId");
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
      return 'assets/images/avatar.png'; // Use a local fallback image
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
      // Optionally show a message to the user about empty messages
      return;
    }

    _isSendingMessage = true;
    notifyListeners();

    try {
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

      messageController.clear();
    } catch (e) {
      print("Error sending message: $e");
      // Optionally show an error message to the user
    } finally {
      _isSendingMessage = false;
      notifyListeners();
    }
  }

 Future<void> updateMessage(String messageId, String newMessage) async {
  if (newMessage.isEmpty) {
    print("Cannot update message to an empty string");
    return;
  }

  print("Updating message: messageId = $messageId, userId = $userId, projectId = $projectId, communityId = $communityId");

  try {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection('communities')
        .doc(communityId)
        .collection('chat_messages')
        .doc(messageId)
        .update({
      'message': newMessage,
      'timestamp': FieldValue.serverTimestamp(), // Optionally update the timestamp
    });
  } catch (e) {
    print("Error updating message: $e");
  }
}

Future<void> deleteMessage(String messageId) async {
  try {
    print("Deleting message: messageId = $messageId, userId = $userId, projectId = $projectId, communityId = $communityId");

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection('communities')
        .doc(communityId)
        .collection('chat_messages')
        .doc(messageId)
        .delete();
  } catch (e) {
    print("Error deleting message: $e");
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
      message: doc['message'],
      isReceived: doc['isReceived'],
      userName: doc['userName'] ?? 'Unknown User',
      userImage: doc['image_user'] ?? '',
      timestamp: doc['timestamp'],
    );
  }
}
