# Pet Growth Partner: 프로젝트 아키텍처 개요 (Overview)

**최종 수정:** 2025년 8월 18일

## 1. 개요

이 문서는 'Pet Growth Partner' 앱의 전체적인 폴더 구조와 각 Dart 파일의 핵심 역할을 설명하는 기술 설계도입니다. 이 문서는 새로운 개발자가 프로젝트에 빠르게 적응하고, 기존 개발자가 아키텍처의 일관성을 유지하는 것을 돕는 것을 목표로 합니다.

---

## 2. 최상위 폴더 구조

- **/lib**: Flutter 앱의 모든 Dart 소스 코드가 위치하는 메인 폴더입니다.
- **/assets**: 앱에서 사용되는 이미지, 아이콘, 폰트 등의 정적 파일을 관리합니다.
- **/android**, **/ios**, **/web**: 각 플랫폼별 네이티브 설정 및 코드를 포함합니다.
- **blueprint.md**: 프로젝트의 개발 방향과 목표를 정의하는 최상위 기획 문서입니다.
- **overview.md**: (바로 이 파일) 프로젝트의 기술적인 구조와 파일의 역할을 정의하는 설계 문서입니다.

---

## 3. /lib 폴더 상세 구조

`/lib` 폴더는 기능별로 하위 폴더를 구성하여 관심사를 분리합니다.

### 📂 `main.dart`

- **역할:** 앱의 시작점(Entry Point)입니다.
- **주요 기능:**
    - Firebase 초기화
    - `ChangeNotifierProvider`를 사용하여 `AuthService`와 같은 최상위 서비스를 앱 전체에 제공
    - `AuthWrapper`를 통해 사용자의 인증 상태에 따라 `LoginPage` 또는 `HomePage`를 표시하는 로직 제어

### 📂 /data

- **역할:** 앱 전체에서 사용될 정적인 데이터 목록을 관리합니다. (예: 강아지 품종 목록, 스킬 데이터베이스 등)
- **`skills_database.dart` (예정):** 앱에서 사용 가능한 모든 `Skill`의 정보를 미리 정의해 둔 로컬 데이터베이스입니다.

### 📂 /models

- **역할:** Firestore 데이터베이스의 문서 구조를 Dart 클래스로 변환해주는 데이터 모델을 정의합니다.
- **`dog_model.dart`:** `users/{userId}/dogs/{dogId}` 문서의 데이터를 담는 `Dog` 클래스입니다.
- **`skill_model.dart` (예정):** 스킬의 정보를 담는 `Skill` 클래스입니다.
- **`user_model.dart`:** `users/{userId}` 문서의 데이터를 담는 `UserModel` 클래스입니다.

### 📂 /screens

- **역할:** 앱의 각 페이지(화면)에 해당하는 UI 위젯들을 관리합니다.
- **/home_page.dart**: 로그인 후 가장 먼저 보게 되는 메인 대시보드 화면입니다.
- **/login_page.dart**: 앱의 로그인 화면입니다. (개발 중에는 익명 인증 사용)
- **/my_dogs**:
    - **my_dogs_page.dart**: 사용자가 등록한 모든 '디지털 신분증'(`DogIdCardWidget`)을 `PageView`로 보여주는 화면입니다.
- **/survey**:
    - **survey_screen.dart**: 여러 페이지로 구성된 설문지의 전체적인 흐름(페이지 전환, 프로그레스 바, 제출 로직)을 관리하는 메인 컨테이너입니다.
    - **/pages**: 설문지의 각 단계를 구성하는 개별 페이지 위젯들이 위치합니다.
- **/training (예정)**:
    - **training_page.dart**: AI가 생성한 '훈련 퀘스트' 목록을 보여주고, 사용자가 훈련 진행 상황을 기록하는 화면입니다.

### 📂 /services

- **역할:** Firebase와의 통신, AI 모델 호출 등 앱의 핵심 비즈니스 로직 및 백엔드 작업을 처리합니다. UI로부터 로직을 분리하는 중요한 역할을 합니다.
- **`auth_service.dart`:** Firebase Authentication을 사용한 사용자 인증(익명, Google 등) 및 로그아웃 처리를 담당합니다.
- **`dog_service.dart`:** Firestore의 `dogs` 컬렉션에 대한 데이터 생성(Create), 읽기(Read), 수정(Update), 삭제(Delete) 작업을 담당합니다.
- **`ai_service.dart` (예정):** 사용자의 반려견 데이터를 입력받아 Gemma AI 모델을 호출하고, '맞춤 훈련 퀘스트'를 생성하여 반환하는 로직을 담당합니다.

### 📂 /widgets

- **역할:** 여러 화면에서 재사용될 수 있는 공통 UI 컴포넌트를 관리합니다.
- **`dog_id_card_widget.dart`:** '디지털 신분증'의 UI를 담당하는 핵심 위젯입니다. 반려견의 정보와 획득한 스킬 등을 시각적으로 표시합니다.
