import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/admin/admin_cat_gorie_screen/admin_cat_gorie_screen.dart';
import 'package:rifund/screens/admin/admin_communaut_screen/admin_communaut_screen.dart';
import 'package:rifund/screens/admin/admin_projet_screen/admin_projet_screen/admin_projet_screen.dart';

import 'package:rifund/screens/admin/admin_utlisa_page/admin_utlisa_page.dart';
import 'package:rifund/screens/admin/profile_admin_page/profile_admin_page.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminProjetScreen()));
        } else if (index == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AdminUtlisaPage()));
        } else if (index == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminCategoryScreen()));
        } else if (index == 3) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminCommunautScreen()));
        } else if (index == 4) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProfileAdminPage()));
        }
        setState(() {});
      },
      height: 70,
      color: Colors.lightGreen.shade600,
      items: [
        Icon(
          Icons.business,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.person_add,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.category,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.chat,
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
