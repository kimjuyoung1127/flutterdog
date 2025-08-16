# Pet Growth Partner: 프로젝트 아키텍처 개요 (Overview)

**최종 수정:** 2025년 8월 19일

## 1. 개요

이 문서는 'Pet Growth Partner' 앱의 전체적인 폴더 구조와 각 Dart 파일의 핵심 역할을 설명하는 기술 설계도입니다. 이 문서는 새로운 개발자가 프로젝트에 빠르게 적응하고, 기존 개발자가 아키텍처의 일관성을 유지하는 것을 돕는 것을 목표로 합니다.

---

## 2. /lib 폴더 상세 구조

`/lib` 폴더는 기능별로 하위 폴더를 구성하여 관심사를 분리합니다.

### 📂 `main.dart`

- **역할:** 앱의 시작점(Entry Point)입니다.
- **주요 기능:**
    - Firebase 초기화
    - `ChangeNotifierProvider`를 사용하여 `AuthService` 제공
    - `AuthWrapper`를 통해 인증 상태에 따라 `LoginPage` 또는 `HomePage` 표시

### 📂 /data

- **역할:** 앱 전체에서 사용될 정적인 데이터 목록을 관리합니다.
- **`skill_tree_database.dart` (✅ 완료):** 모든 `Skill`의 정보를 정의한 로컬 데이터베이스.
- **`item_database.dart` (✅ 완료):** 모든 `Item`의 정보를 정의한 로컬 데이터베이스.

### 📂 /models

- **역할:** Firestore 데이터 구조를 Dart 클래스로 변환하는 데이터 모델을 정의합니다.
- **`dog_model.dart` (✅ 완료):** `Dog` 클래스. 클래스, 스킬, 아이템 등 성장 시스템 필드를 포함.
- **`skill_model.dart` (✅ 완료):** `Skill` 클래스.
- **`item_model.dart` (✅ 완료):** `Item` 클래스.
- **`user_model.dart` (✅ 완료):** `UserModel` 클래스.

### 📂 /screens

- **역할:** 앱의 각 페이지(화면)에 해당하는 UI 위젯들을 관리합니다.
- **/home_page.dart**: 메인 대시보드 화면.
- **/login_page.dart**: 로그인 화면 (개발 중 익명 인증 사용).
- **/my_dogs**:
    - **my_dogs_page.dart**: '디지털 신분증' 목록을 보여주는 화면.
- **/survey**:
    - **survey_screen.dart**: 설문지의 전체 흐름을 관리하는 컨테이너.
    - **/pages**: 설문지의 각 개별 페이지 위젯.
- **/training**:
    - **skill_tree_page.dart` (✅ 완료):** 클래스를 선택하고, TP를 투자하여 스킬을 배우는 화면.
    - **inventory_page.dart` (✅ 완료):** 획득한 아이템을 보고 장착/해제하는 화면.

### 📂 /services

- **역할:** Firebase 통신 등 핵심 비즈니스 로직 및 백엔드 작업을 처리합니다.
- **`auth_service.dart` (✅ 완료):** 사용자 인증 담당.
- **`dog_service.dart` (✅ 완료):** 강아지 데이터 CRUD 및 스킬/아이템 장착 등 핵심 게임 로직 담당.
- **`ai_service.dart` (예정):** AI 모델을 호출하여 '맞춤 훈련 퀘스트'를 생성하는 로직 담당.

### 📂 /widgets

- **역할:** 여러 화면에서 재사용될 수 있는 공통 UI 컴포넌트를 관리합니다.
- **`dog_id_card_widget.dart`:** '디지털 신분증'의 UI를 담당하는 핵심 위젯. (업데이트 필요)
