import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_collection/components/color_comp.dart';
import 'package:mobile_collection/feature/assignment/assignment_screen.dart';
import 'package:mobile_collection/feature/home/home_screen.dart';
import 'package:mobile_collection/feature/notification/notification_screen.dart';
import 'package:mobile_collection/feature/profile/profile_screen.dart';
import 'package:mobile_collection/feature/tab/provider/tab_provider.dart';
import 'package:provider/provider.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  Widget _getPage(int index) {
    if (index == 0) {
      return const HomeScreen();
    }
    if (index == 1) {
      return const AssignmentScreen();
    }
    if (index == 2) {
      return const NotificationScreen();
    }
    if (index == 3) {
      return const ProfileScreen();
    }

    return const HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarProvider = Provider.of<TabProvider>(context);
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomBarProvider.page,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: (index) {
            bottomBarProvider.setPage(index);
            bottomBarProvider.setTab(0);
          },
          iconSize: 18,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          selectedLabelStyle: const TextStyle(
              fontSize: 13,
              color: primaryColor,
              height: 1.5,
              fontWeight: FontWeight.w600),
          elevation: 0,
          selectedIconTheme: const IconThemeData(color: primaryColor),
          selectedItemColor: primaryColor,
          unselectedItemColor: const Color(0xFF575551),
          unselectedLabelStyle: const TextStyle(
              color: Color(0xFF575551),
              height: 1.5,
              fontWeight: FontWeight.w600),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icon/home.svg',
                color: const Color(0xFF484C52),
                height: 24,
                width: 24,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icon/home.svg',
                color: primaryColor,
                height: 24,
                width: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icon/application.svg',
                color: const Color(0xFF484C52),
                height: 24,
                width: 24,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icon/application.svg',
                color: primaryColor,
                height: 24,
                width: 24,
              ),
              label: 'Task List',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icon/notif.svg',
                color: const Color(0xFF484C52),
                height: 24,
                width: 24,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icon/notif.svg',
                color: primaryColor,
                height: 24,
                width: 24,
              ),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icon/profile.svg',
                color: const Color(0xFF484C52),
                height: 24,
                width: 24,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icon/profile.svg',
                color: primaryColor,
                height: 24,
                width: 24,
              ),
              label: 'Profile',
            ),
          ],
        ),
        body: _getPage(bottomBarProvider.page));
  }
}
