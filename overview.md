# Pet Growth Partner: 프로젝트 아키텍처 개요 (Overview)

**최종 수정:** 2025년 8월 20일

## 1. 개요
이 문서는 'Pet Growth Partner' 앱의 전체적인 폴더 구조와 각 Dart 파일의 핵심 역할을 설명하는 기술 설계도입니다. 이 문서는 `blueprint.md`의 기획을 어떤 기술 구조로 구현했는지 보여주는 것을 목표로 합니다.

## 2. 핵심 기능 및 아키텍처 흐름

이 앱은 **AI 기반 성장 시스템**을 중심으로 작동하며, 주요 아키텍처 흐름은 다음과 같습니다.

1.  **데이터 모델 (`/models`):** `Dog`, `Skill`, `Item`, `Material`, `Quest` 등 모든 게임 요소의 데이터 구조를 정의합니다.
2.  **정적 데이터베이스 (`/data`):** `SkillTreeDatabase`, `ItemDatabase` 등 게임의 규칙과 보상 정보를 담고 있는 로컬 DB 역할을 합니다.
3.  **백엔드 서비스 (`/services`):**
    *   `DogService`: Firestore와 통신하여 `Dog` 객체의 데이터를 관리(CRUD)하고, 스킬 학습/아이템 장착 등 핵심 게임 로직을 처리합니다.
    *   `AIService`: `Dog` 객체의 데이터를 분석하여 Firebase AI(Gemini)에 전달하고, 맞춤형 `Quest` 목록을 생성하여 반환합니다.
4.  **UI/화면 (`/screens`):**
    *   사용자는 `MyDogsPage`에서 '디지털 신분증'(`DogIdCardWidget`)을 통해 반려견의 성장을 확인합니다.
    *   `SkillTreePage`와 `InventoryPage`에서 재료와 TP를 소모하여 반려견을 성장시킵니다.
    *   `TrainingPage`에서 `AIService`가 생성한 퀘스트를 받아 훈련을 진행합니다.

---

## 3. /lib 폴더 상세 구조

### 📂 /data
-   **역할:** 게임의 규칙과 밸런스를 정의하는 정적 데이터베이스.
-   **`skill_tree_database.dart` (✅ 완료):** 4대 클래스의 모든 스킬 트리, 필요 재료/TP, 보상 등을 정의.
-   **`item_database.dart` (✅ 완료):** 모든 '장비 아이템'의 능력치, 장착 부위 등을 정의.
-   **`material_database.dart` (✅ 완료):** 모든 '훈련 재료'의 정보를 정의.

### 📂 /models
-   **역할:** Firestore 데이터 구조 및 게임 내 객체를 정의하는 Dart 클래스.
-   **`dog_model.dart` (✅ 완료):** 반려견의 모든 정보(프로필, 클래스, 스킬, 인벤토리 등)를 담는 핵심 모델.
-   **`skill_model.dart` (✅ 완료):** 스킬의 속성(클래스, 필요 재료/TP, 태그 등)을 정의.
-   **`item_model.dart` (✅ 완료):** '장비 아이템'의 속성(능력치, 장착 부위 등)을 정의.
-   **`material_model.dart` (✅ 완료):** '훈련 재료'의 속성을 정의.
-   **`quest_model.dart` (✅ 완료):** AI가 생성하는 퀘스트의 구조(제목, 설명, 보상 등)를 정의.

### 📂 /screens
-   **역할:** 앱의 각 페이지(화면)에 해당하는 UI 위젯.
-   **/my_dogs/my_dogs_page.dart` (✅ 완료):** 사용자의 모든 반려견 '디지털 신분증'을 보여주는 메인 화면.
-   **/training/skill_tree_page.dart` (✅ 완료):** 클래스를 선택하고 스킬을 '제작'하는 화면.
-   **/training/inventory_page.dart` (✅ 완료):** 획득한 아이템과 재료를 확인하고 장비를 장착하는 화면.
-   **/training/training_page.dart` (✅ 완료):** `AIService`가 생성한 퀘스트 목록을 보여주는 '퀘스트 보드'.
-   **/survey/survey_screen.dart` (✅ 완료):** 반려견의 프로필을 입력/수정하는 설문 화면.

### 📂 /services
-   **역할:** Firebase와의 통신 등 백엔드 로직을 처리하는 서비스 계층.
-   **`auth_service.dart` (✅ 완료):** 사용자 인증 담당.
-   **`dog_service.dart` (✅ 완료):** 강아지 데이터 CRUD 및 핵심 게임 로직(스킬 학습, 아이템 장착) 담당.
-   **`ai_service.dart` (✅ 완료):** `Dog` 프로필을 분석하여 AI에 전달하고, 맞춤 훈련 퀘스트를 생성하는 로직 담당.

### 📂 /widgets
-   **역할:** 여러 화면에서 재사용되는 공통 UI 컴포넌트.
-   **`dog_id_card_widget.dart` (✅ 완료):** 반려견의 모든 성장 상태(클래스, 장비, 스킬)를 보여주는 핵심 '캐릭터 정보창' 위젯.
