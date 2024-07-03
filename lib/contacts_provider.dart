// contacts_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './contact.dart'; // Adjust as per your project structure

class ContactsProvider extends ChangeNotifier {
  List<SimpleContact> _contacts = [];
  List<SimpleContact> _filteredcontacts = [];
  String _SearchQuery = '';

  List<SimpleContact> _widget1GroupFilteredContacts = [];
  List<SimpleContact> _widget2GroupFilteredContacts = [];
  List<SimpleContact> _widget3GroupFilteredContacts = [];

  List<String> _nowGroup = ['all_groups','all_groups','all_groups'];

  List<SimpleContact> get contacts => _contacts; //외부에서 contacts로 접근할때 _contacts와 같게 취급
  List<SimpleContact> get filteredcontacts => _filteredcontacts; //외부에서 filteredcontacts로 접근할때 _filteredcontacts와 같게 취급
  List<SimpleContact> get widget1GroupFilteredContacts => _widget1GroupFilteredContacts;
  List<SimpleContact> get widget2GroupFilteredContacts => _widget2GroupFilteredContacts;
  List<SimpleContact> get widget3GroupFilteredContacts => _widget3GroupFilteredContacts;
  List<String> get nowGroup => _nowGroup;

  ContactsProvider() {
    //첫 Contacts가 생성될때 실행되는 함수, load만으로 가져옴
    _loadContacts();
  }

  Future<void> _loadContacts() async { //기본적으로 load하고, 만약 비어있으면 json에서 가져오는 함수
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? jsonContacts = prefs.getStringList('contacts');
      //sharedPreferences에서 app 내 data 가져오기
      if (jsonContacts != null) { //app 내 data로 _contacts 만들기
        _contacts = jsonContacts.map((jsonContact) => SimpleContact.fromJson(jsonDecode(jsonContact))).toList();
      } else { //app내 data가 없을때 json으로 _contacts 만들기
        // If no contacts in SharedPreferences, load from asset file
        final jsonString = await rootBundle.loadString('assets/contacts.json');
        final List<dynamic> jsonData = jsonDecode(jsonString);
        _contacts = jsonData.map((item) => SimpleContact.fromJson(item)).toList();
      }
      contactsChangeFunctions();
    } catch (e) {
      print('Error loading contacts: $e');
      // Handle error as needed (e.g., show error message)
    }
  }

  void _filterContacts() { // 상태관리 함수 3호 검색어랑 매칭해서 확인하기
    if (_SearchQuery.isEmpty) {
      _filteredcontacts = _contacts;
    } else {
      _filteredcontacts = _contacts
          .where((contact) => contact.name.toLowerCase().contains(_SearchQuery.toLowerCase()))
          .toList();
    }
  }

  void _widget1filterGroupContacts() { // 상태관리 함수 3호 검색어랑 매칭해서 확인하기
    if (_nowGroup[0]=='all_groups') {
      _widget1GroupFilteredContacts = _filteredcontacts;
    } else {
      _widget1GroupFilteredContacts = _filteredcontacts
          .where((contact) => contact.group==_nowGroup[0])
          .toList();
    }
  }

  void _widget2filterGroupContacts() { // 상태관리 함수 3호 검색어랑 매칭해서 확인하기
    if (_nowGroup[1]=='all_groups') {
      _widget2GroupFilteredContacts = _contacts;
    } else {
      _widget2GroupFilteredContacts = _contacts
          .where((contact) => contact.group==_nowGroup[1])
          .toList();
    }
  }

  void _widget3filterGroupContacts() { // 상태관리 함수 3호 검색어랑 매칭해서 확인하기
    if (_nowGroup[2]=='all_groups') {
      _widget3GroupFilteredContacts = _contacts;
    } else {
      _widget3GroupFilteredContacts = _contacts
          .where((contact) => contact.group==_nowGroup[2])
          .toList();
    }
  }



  Future<void> _saveContacts() async { //sharedpreferences로 저장 (수정할때 마다 선언 필요)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonContacts = _contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await prefs.setStringList('contacts', jsonContacts);
  }

  void _sortContacts(){ // ㄱㄴㄷ순 정렬, _updateIndexes는 인덱스 실제 배열하고 같게 해서 _contacts에 저장
    _contacts.sort((a,b)=> a.name.compareTo(b.name));
    _updateIndexes();
  }

  void _updateIndexes() {
    for (int i = 0; i < _contacts.length; i++) {
      _contacts[i].index = i;
    }
  }


  void addContact(SimpleContact contact) { //추가하기
    _contacts.add(contact);
    contactsChangeFunctions();
  }

  void updateContact(int index, SimpleContact updatedContact) { //수정하기
    if (index >= 0 && index < _contacts.length) {
      _contacts[index] = updatedContact;
      contactsChangeFunctions();
    }
  }
  void deleteContact(int index) { //삭제하기
    if (index >= 0 && index < _contacts.length) {
      _contacts.removeAt(index);
      contactsChangeFunctions();
    }
  }

  void updateSearchQuery(String query) { // 검색할때 Query가 변경되었을때 사용되는 함수
    _SearchQuery = query;
    _filterContacts();
    _widget1filterGroupContacts();
    notifyListeners();
  }
  void initializeQuery(){
    _SearchQuery = '';
    _filterContacts();
    _widget1filterGroupContacts();
  }

  void updateNowGroup(List<String> nowGroup, int widget) {
    _nowGroup = nowGroup;
    if(widget==0) {
      _widget1filterGroupContacts();
    } else if(widget==1){
      _widget2filterGroupContacts();
    } else if(widget==2){
      _widget3filterGroupContacts();
    }
    notifyListeners();
  }

  void contactsChangeFunctions(){ //contacts값이 바뀌었을떄 선언해야하는 모든 함수
    _sortContacts(); // 정렬하고
    _saveContacts(); // 저장하고
    _filterContacts(); //검색 다시 확인하고
    _widget1filterGroupContacts();
    _widget2filterGroupContacts();
    _widget3filterGroupContacts(); //3개의 tab의 group기반 다시 확인하고
    notifyListeners(); // 바뀐것을 알려준다!
  }
  void removeGroup(String group, int widgetFrom){
    for(int index=0; index < _contacts.length; index ++){
      if (_contacts[index].group== group) {
        _contacts[index].group = '기타';
      }
    }
    for(int i=0;i<3;i++){
      if(_nowGroup[i]==group){
        _nowGroup[i]='기타';
        updateNowGroup(_nowGroup, i);
      }
    }
    contactsChangeFunctions();
  }
}