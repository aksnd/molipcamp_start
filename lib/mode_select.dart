import 'package:flutter/material.dart';
import 'whoe_quiz_page.dart';
import 'simple_quiz_page.dart';

class ModeSelectionPage extends StatefulWidget {
  @override
  _ModeSelectionPageState createState() => _ModeSelectionPageState();
}

class _ModeSelectionPageState extends State<ModeSelectionPage> {

  String? selectedGroup;
  List<String> groups = ['그룹 A', '그룹 B', '그룹 C']; //바꿔야함!!!!!!!!!!!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('퀴즈 모드 및 그룹 선택'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              hint: Text('그룹 선택'),
              value: selectedGroup,
              items: groups.map((String group) {
                return DropdownMenuItem<String>(
                  value: group,
                  child: Text(group),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGroup = newValue;
                });
              },
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: selectedGroup == null
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => free_page(
                          selectedGroup: selectedGroup!,
                        ),
                      ),
                    );
                  },
                  child: Text('전체 문제 모드'),
                ),
                ElevatedButton(
                  onPressed: selectedGroup == null
                ? null
        : () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => simple_page(selectedGroup: selectedGroup!),
    ),
    );
    },
                  child: Text('4문제 모드 (비활성화)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
