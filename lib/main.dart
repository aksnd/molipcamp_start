import 'package:flutter/material.dart';
import './gallery.dart';
import './free_page.dart';
import './phone_number.dart';
/// Flutter code sample for [BottomNavigationBar].

void main() => runApp(const projectapp1());

class projectapp1 extends StatelessWidget {
  const projectapp1({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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

  List _pages = [
    phone_number(),
    gallery(),
    free_page(),
  ];
  static const List<Widget> _widgetOptions = <Widget>[
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '전화번호',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '갤러리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '자유주제',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}