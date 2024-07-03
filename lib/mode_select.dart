import 'package:flutter/material.dart';
import 'whoe_quiz_page.dart';

import 'contacts_provider.dart';
import 'groups_provider.dart';
import './dialog.dart';
import 'package:provider/provider.dart';

class ModeSelectionPage extends StatefulWidget {
  @override
  _ModeSelectionPageState createState() => _ModeSelectionPageState();
}

class _ModeSelectionPageState extends State<ModeSelectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ContactsProvider, GroupsProvider>(
        builder: (context, contactsProvider, groupsProvider, child) {
      final groups = groupsProvider.groups;
      List<String> dropDownGroup = contactsProvider.nowGroup;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '퀴즈 그룹 선택',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_downward, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "어떤 그룹으로 퀴즈게임을 진행하시겠어요?",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0xFF023047),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                            width: 180,
                            alignment: Alignment.centerRight,
                            child: GroupDropdown(
                              groups: groups,
                              selectedGroup: dropDownGroup[2],
                              onGroupChanged: (String newGroup) {
                                dropDownGroup[2] = newGroup;
                                Provider.of<ContactsProvider>(context,
                                        listen: false)
                                    .updateNowGroup(dropDownGroup, 2);
                              },
                              widgetFrom: 2,
                            )),
                      ),
                    );
                  }),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => free_page(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8ECAE6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                child: Text(
                  '퀴즈 시작!',
                  style: TextStyle(color: Color(0xFF023047)),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
