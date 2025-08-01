import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'stats_screen.dart';
import '../routes/app_routes.dart';
import '../utils/app_theme.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    StatsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addTransaction),
        child: Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home,
                    color: _selectedIndex == 0
                        ? AppTheme.primaryColor
                        : Colors.grey),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(Icons.bar_chart,
                    color: _selectedIndex == 1
                        ? AppTheme.primaryColor
                        : Colors.grey),
                onPressed: () => _onItemTapped(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}