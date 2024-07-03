# 몰입캠프 1주차 프로젝트  C-napse Game

친구, 가족, 연인등의 정보를 기억하고 사진을 볼수 있는 연락처 및 퀴즈 앱

### 개발기간: 24.06.27~24.07.02(몰입캠프 1주차)

# [1] 개발 환경

- 개발 언어 : Flutter
- 버전 및 이슈관리 : Github
- 협업 툴 : Discord, Notion
- 디자인 : Figma

# [2] About the project (프로젝트 기능)
이 앱은 총 3개의 탭으로 이루어져 있으며, 3개의 탭이 유기적으로 연결되어 사용
각 탭이 공통된 전화번호 객체를 이용하며, 해당 객체는 이름, 전화번호, 생일, MBTI, group, 이미지의 값을 보유함.

### 탭 1 - 전화번호부 탭
- 그룹별로 전화번호를 보여줌
- 전화버튼을 통한 전화 앱 연결
- 핸드폰 내의 전화번호부에 해당 연락처 저장, 전화번호부로부터 load 기능
- 추가 버튼을 통한 새로운 전화번호 저장
- 전화번호 ListView 클릭을 통한 팝업으로 수정 및 삭제가능

### 탭 2 - 이미지 탭
- 그룹별로 이미지 보여주기
- 사진 클릭을 통한 해당 인원의 값들 조회가능
- 기본사진의 경우 이미지 탭에서 뜨지 않도록 예외처리 진행 

### 탭 3 - 퀴즈 탭
- 이미지를 보고 이름을 맞추는 퀴즈 출제
- 이미지와 이름 모두를 보고 MBTI, 전화번호, 생일 퀴즈 출제
- 퀴즈 정답률을 기반으로 한 랭킹 기능 구현
- 

# [3] Project Skills (프로젝트 기술)

### 주요 라이브러리 
- shared_Preferences - <https://pub.dev/packages/shared_preferences>
- image_Picker - <https://pub.dev/packages/image_picker>
- flutter_native_contact_picker - <https://pub.dev/packages/flutter_native_contact_picker>
- contacts_service - <https://pub.dev/documentation/contacts_service/latest/>
- provider - <https://pub.dev/packages/provider>

### 주요 technology
imagePicker 이용 갤러리, 카메라 접근
SharedPreference와 provider를 이용한 탭별 자료 연계 및 local 저장 (contacts, ranking, groups)
flutter_native_contact_picker와 contacts_service를 이용한 전화번호부 연동
dropdown 이용하여 탭별 자료 연계

# [4] 구동 방법
'git clone https://github.com/your_username/your_flutter_app.git' 으로 clone
'flutter pub get' 후 'flutter run' 으로 실행



# [5] 개발 멤버

## 박지훈 <https://github.com/aksnd>
- 전화번호 CRUD System 구현(SharedPreference), 갤러리를 연결하여 사진 업로드 기능 구현(imagePicker), provider를 이용한 탭별 Contact 객체 구현, bottomnavigator 구현
- local 전화번호부 연결(save, load), search(검색) sort(정렬)기능 구현, group system support 
## 김예락 <https://github.com/kimyerak>
- 3번탭(quiz) 전체 구현(UI 및 quiz관련 상태관리), overall UI/UX design, ranking system 구현
## 박윤서 <https://github.com/yunseopark-kaist>
- 1,2번탭 UI/UX design, image load 기능 구현, group system 구현


