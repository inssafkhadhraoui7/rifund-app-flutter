import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import
import 'package:flutter/material.dart';

import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> notifications = [];

  Future<void> fetchNotifications(String userId) async {
    try {
      notifications.clear();

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .get();

      notifications = snapshot.docs
          .map((doc) =>
              NotificationModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (e) {
      print("Erreur de chargement: $e");
    }
  }

  // Other methods (addNotification, markNotificationAsRead, etc.) remain unchanged
}
