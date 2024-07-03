import 'package:flutter/material.dart';
import './gallery.dart';
import './whoe_quiz_page.dart';
import './contactlist.dart';
import 'contacts_provider.dart';
import 'ranking_provider.dart';
import 'groups_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import './mode_select.dart';

void main(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const projectapp1());
}

class projectapp1 extends StatelessWidget {
  const projectapp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( // ChangeNotifierProvider 대신 MultiProvider 사용
      providers: [
        ChangeNotifierProvider(create: (context) => ContactsProvider()),
        ChangeNotifierProvider(create: (context) => RankingProvider()), // 추가: RankingProvider 등록
        ChangeNotifierProvider(create: (context)=> GroupsProvider()),
      ],
      child: MaterialApp(
        title: '몰입캠프 첫 project',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF023047),
          appBarTheme: AppBarTheme(
            color: Color(0xFF023047),
          ),
          scaffoldBackgroundColor: Color(0xFF023047),
        ),
        home: NavigationBarWidget(), // Adjust this based on your starting point
      ),
    );
  }
}

class NavigationBarWidget extends StatefulWidget {
  final int initialIndex;
  const NavigationBarWidget({super.key, this.initialIndex = 0});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarWidget> {
  int _selectedIndex = 0;



  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

    });
  }





  @override
  Widget build(BuildContext context) {
    List _pages = [
      phone_number(),
      gallery(),
      ModeSelectionPage(),
    ];

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
        selectedItemColor: Color(0xFF3AB349),
        onTap: _onItemTapped,
      ),
    );
  }
}