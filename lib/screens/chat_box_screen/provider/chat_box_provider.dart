import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_box_model.dart';
class ChatBoxProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();
  
  List<Message> messages = [];

  ChatBoxModel chatBoxModelObj = ChatBoxModel();

  ChatBoxProvider() {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    _firestore.collection('chat_messages').orderBy('timestamp').snapshots().listen((snapshot) {
      messages = snapshot.docs.map((doc) => Message.fromDocument(doc)).toList();
      notifyListeners();
    });
  }

  Future<void> sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await _firestore.collection('chat_messages').add({
        'message': messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'isReceived': false, // Adjust based on your logic
      });
      messageController.clear();
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}

// Message class to hold message data
class Message {
  final String message;
  final bool isReceived;

  Message({required this.message, required this.isReceived});

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      message: doc['message'] ?? '',
      isReceived: doc['isReceived'] ?? false,
    );
  }
}
