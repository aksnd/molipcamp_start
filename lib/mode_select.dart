import 'package:flutter/material.dart';
import 'whoe_quiz_page.dart';
import 'simple_quiz_page.dart';
import 'contacts_provider.dart';
import 'groups_provider.dart';
import './dialog.dart';
import 'package:provider/provider.dart';
class ModeSelectionPage extends StatefulWidget {
  @override
  _ModeSelectionPageState createState() => _ModeSelectionPageState();
}

class _ModeSelectionPageState extends State<ModeSelectionPage> {

  @override
  Widget build(BuildContext context) {
    return Consumer2<ContactsProvider,GroupsProvider>(
      builder: (context,contactsProvider, groupsProvider, child) {
        final groups = groupsProvider.groups;
        List<String> dropDownGroup = contactsProvider.nowGroup;
        return Scaffold(
          appBar: AppBar(
            title: Text('퀴즈 모드 및 그룹 선택'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 130,
                  alignment: Alignment.centerRight,
                  child:Flexible(
                      child: GroupDropdown(
                        groups: groups,
                        selectedGroup: dropDownGroup[2],
                        onGroupChanged:(String newGroup){
                          dropDownGroup[2]= newGroup;
                          Provider.of<ContactsProvider>(context, listen: false).updateNowGroup(dropDownGroup, 2);
                        },
                        isEdit: false,
                      )
                  )
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => free_page(),
                          ),
                        );
                      },
                      child: Text('전체 문제 모드'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                          Navigator.push(
                            context,
                              MaterialPageRoute(
                                builder: (context) => simple_page(selectedGroup: dropDownGroup[2]),
                              ),
                          );},
                      child: Text('4문제 모드 (비활성화)'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
