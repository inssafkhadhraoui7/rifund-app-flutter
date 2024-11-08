import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:rifund/core/app_export.dart';
import 'package:rifund/screens/main_page/providers/main_page_provider.dart';

import '../acceuil_client_page/acceuil_client_page.dart';
import '../creationprojet/creationprojet.dart';
import '../notification_page/notification_page.dart';
import '../profile_screen/profile_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static Widget builder(BuildContext context){
    return ChangeNotifierProvider(
      create: (context) => MainPageProvider(),
      child: const MainPage(),
    );
  }

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AcceuilClientPage(),
    const CrErProjetScreen(),
    const NotificationPage(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        height: 70,
        color: Colors.lightGreen.shade600,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
      ),
    );
  }
}
