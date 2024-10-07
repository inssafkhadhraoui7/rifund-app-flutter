import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/acceuil_client_page/acceuil_client_page.dart';
import 'package:rifund/screens/creationprojet/creationprojet.dart';
import 'package:rifund/screens/notification_page/notification_page.dart';
import 'package:rifund/screens/profile_screen/profile_screen.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AcceuilClientPage()));
        } else if (index == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CrErProjetScreen()));
        } else if (index == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationPage()));
        } else if (index == 3) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()));
        }
        setState(() {});
      },
      height: 70,
      color: Colors.lightGreen.shade600,
      items: const [
        Icon(
          Icons.home,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.note_add,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.notifications_active,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.person,
          size: 30,
          color: Colors.white,
        ),
      ],
    );
  }

  void setState(Null Function() param0) {}
}
