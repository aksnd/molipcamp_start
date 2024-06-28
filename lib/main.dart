import 'package:flutter/material.dart';
import './gallery.dart';
import './free_page.dart';
import './contactlist.dart';
import './contact.dart';
import 'dart:convert';

/// Flutter code sample for [BottomNavigationBar].


void main() => runApp(const projectapp1());

class projectapp1 extends StatelessWidget {
  const projectapp1({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "몰입캠프 첫 project",
      home: NavigationBarWidget(),
    );
  }
}

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  State<NavigationBarWidget> createState() =>
      _NavigationBarState();

}


class _NavigationBarState extends State<NavigationBarWidget> {
  int _selectedIndex = 0;
  List<Contact> _contacts = [];
  List _pages = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _loadPages();
  }

  Future<void> _loadContacts() async {
    // Replace with your actual loading mechanism
    final String response = ''; // Load contacts from asset or network
    if (response.isNotEmpty) {
      final List<dynamic> data = json.decode(response);
      setState(() {
        _contacts = data.map((contact) => Contact.fromJson(contact)).toList();
        _loadPages();
      });
    } else {
      // Handle case where response is empty or failed to load
      // For now, initialize with empty data or default values
      setState(() {
        _contacts = [];
        _loadPages();
      });
    }
  }
  void _loadPages() {
    // Initialize _pages list with the appropriate pages based on _contacts data
    _pages = [
      phone_number(),
      gallery(),
      QuizPage(contacts: _contacts), // Updated to pass the contacts list
    ];
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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