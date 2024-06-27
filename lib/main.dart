import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요

void main() => runApp(MyApp()); //main에서 MyApp이란 클래스를 호출한다.

class MyApp extends StatelessWidget {
  //MyApp 클래스 선언
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'my first app',
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: Text("hello world"),
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        actions: [
          IconButton(icon: Icon(Icons.image), onPressed: () {}),
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            ElevatedButton(onPressed: (){showSnackBar(context);}, child: Text("elevated Button")),
          ],
        ),
      ),
    );
  }
}
void showSnackBar(BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
      SnackBar(
        content: Text('snackbar'),
        //snack bar의 내용. icon, button같은것도 가능하다.
        duration: Duration(seconds: 5), //올라와있는 시간
      )
  );
}
