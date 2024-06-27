import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "연락처 목록"),
              Tab(text: "갤러리"),
              Tab(text: "기타"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.call),
            Icon(Icons.account_box),
            Icon(Icons.assignment_outlined),
          ],
        ),
      ),
    ));
  }
}