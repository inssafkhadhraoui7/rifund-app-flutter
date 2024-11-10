import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/acceuil_client_page/acceuil_client_page.dart';
import 'package:rifund/screens/creationprojet/creationprojet.dart';
import 'package:rifund/screens/notification_page/notification_page.dart';
import 'package:rifund/screens/profile_screen/profile_screen.dart';

class BottomNavBar extends StatelessWidget {
  late final String userId;
  Future<int> getUnreadNotificationsCount(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .get();

    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getUnreadNotificationsCount(userId),
      builder: (context, snapshot) {
        int unreadCount = 0;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            unreadCount = snapshot.data ?? 0;
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
        }

        return CurvedNavigationBar(
          backgroundColor: Colors.white,
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AcceuilClientPage()),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CrErProjetScreen()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }
          },
          height: 70,
          color: Colors.lightGreen.shade600,
          items: [
            const Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            const Icon(
              Icons.note_add,
              size: 30,
              color: Colors.white,
            ),
            Stack(
              children: [
                const Icon(
                  Icons.notifications_active,
                  size: 30,
                  color: Colors.white,
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : '$unreadCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
          ],
        );
      },
    );
  }
}

