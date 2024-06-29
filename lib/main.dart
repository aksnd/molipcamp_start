import 'package:flutter/material.dart';
import './gallery.dart';
import './free_page.dart';
import './contactlist.dart';
import 'contacts_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Flutter code sample for [BottomNavigationBar].

void main() => runApp(const projectapp1());

class projectapp1 extends StatelessWidget {
  const projectapp1({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactsProvider(),
      child: MaterialApp(
        title: '몰입캠프 첫 project',
        home: NavigationBarWidget(), // Adjust this based on your starting point
      ),
    );
  }
}

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarWidget> {
  int _selectedIndex = 0;

  List _pages = [
    phone_number(),
    gallery(),
    free_page(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page),
            label: '전화번호 ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_photo),
            label: '갤러리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: '퀴즈',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
