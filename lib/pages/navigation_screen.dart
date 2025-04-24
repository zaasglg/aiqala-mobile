import 'package:aiqala/pages/edu_screen.dart';
import 'package:aiqala/pages/home_screen.dart';
import 'package:aiqala/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    EduScreen(),
    ProfileScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.black26,
                width: 0.5,
              ),
            ),
          ),
          padding: const EdgeInsets.only(top: 9),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(
                  IconlyBroken.home,
                ),
                label: 'Главная',
              ),
              const BottomNavigationBarItem(
                icon: Icon(IconlyBroken.work),
                label: 'Обучение',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: <Widget>[
                    const Icon(IconlyBroken.chat), // Main icon
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Color(0xff003092),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 15,
                          minHeight: 15,
                        ),
                        child: const Text(
                          '0', // The badge count
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                label: 'Чат',
              ),
              const BottomNavigationBarItem(
                icon: Icon(IconlyBroken.profile),
                label: 'Профиль',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xff003092),
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
