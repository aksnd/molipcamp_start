# 몰입캠프 1주차 프로젝트  전화번호부 기반 퀴즈앱 제작

### 개발기간: 24.06.27~24.07.02(몰입캠프 1주차)


# [1] About the project (프로젝트 기능)
이 앱은 총 3개의 탭으로 이루어져 있으며, 3개의 탭이 유기적으로 연결되어 사용

### 탭 1 - 전화번호부 탭
- 그룹별로 전화번호 보여주기
- 전화버튼을 통한 전화 앱 연결
- 핸드폰 내의 전화번호부에 해당 연락처 저장
- 추가 버튼을 통한 새로운 전화번호 저장 (직접 저장과 전화번호부에서 가져오는 2가지 방법 존재)

### 탭 2 - 이미지 탭
- 그룹별로 이미지 보여주기(기본사진 예외처리)
- 사진 클릭을 통한 사람 조회

### 탭 3 - 퀴즈 탭
- 이미지를 통해 이름을, 이름과 이미지를 통해 생일, MBTI, 전화번호를 퀴즈로 풀수 있음
- 랭킹 기능 보유 (local로만 사용 가능)


# [2] Project Skills (프로젝트 기술)

### 주요 라이브러리 
shared_Preferences - <https://pub.dev/packages/shared_preferences>
image_Picker <https://pub.dev/packages/image_picker>
flutter_native_contact_picker <https://pub.dev/packages/flutter_native_contact_picker>
contacts_service
provider

### 주요 기능

# [4] 개발 멤버

## 박지훈 <https://github.com/aksnd>
- 전화번호 CRUD System 구현(SharedPreference), 갤러리를 연결하여 사진 업로드 기능 구현(imagePicker), provider를 이용한 탭별 Contact 객체 구현, bottomnavigator 구현
- local 전화번호부 연결(save, load), search(검색) sort(정렬)기능 구현, group system support 
## 김예락 <https://github.com/kimyerak>
- 3번탭(quiz) 전체 구현(UI 및 quiz관련 상태관리), overall UI/UX design, ranking system 구현
## 박윤서 <https://github.com/yunseopark-kaist>
- 1,2번탭 UI/UX design, image load 기능 구현, group system 구현


