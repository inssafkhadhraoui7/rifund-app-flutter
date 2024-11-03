import '../../../core/app_export.dart';

// ignore_for_file: must_be_immutable
class NotificationModel {
  String? id; // Unique identifier for the notification
  String? title; // Title of the notification
  String? message; // Message content
  DateTime? timestamp; // When the notification was created
  bool isRead; // Status to check if the notification has been read

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.timestamp,
    this.isRead = false,
  });

  // Method to mark notification as read
  void markAsRead() {
    isRead = true;
  }

  // Example method to convert the model to a map (useful for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp?.toIso8601String(),
      'isRead': isRead,
    };
  }

  // Example method to create a NotificationModel from a map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp']) : null,
      isRead: map['isRead'] ?? false,
    );
  }
}
