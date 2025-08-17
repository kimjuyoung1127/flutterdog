# Pet Growth Partner: 프로젝트 아키텍처 개요 (Overview)

**최종 수정:** 2025년 8월 17일

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

## 3. 앱 구조 및 엔트리 포인트

### 📄 main.dart
**역할:** 앱의 진입점. Firebase 초기화, App Check 설정, 인증 상태 관리
- Firebase Core 및 App Check 초기화 (웹/모바일 환경별 설정)
- AuthService를 Provider로 주입하여 전역 인증 상태 관리
- AuthWrapper를 통해 로그인 상태에 따라 HomePage/LoginPage 자동 라우팅
- Material Design 3 테마 및 Google Fonts 적용

### 📂 /screens/core
#### 📄 home_page.dart
**역할:** 앱의 메인 대시보드 화면
- 로그인된 사용자의 첫 화면
- "내 강아지 프로필"로 MyDogsPage 이동
- "산책 시작하기" 버튼 (향후 GPS 기능용 placeholder)
- 로그아웃 기능 제공

#### 📄 login_page.dart
**역할:** 사용자 인증 화면
- 개발용 익명 로그인 기능 (`signInAnonymously`) 활성화
- Google 소셜 로그인 코드 보관 (향후 활성화 예정)
- 로딩 상태 관리 및 에러 처리

---

## 4. /lib 폴더 상세 구조

### 📂 /data
**역할:** 게임의 규칙과 밸런스를 정의하는 정적 데이터베이스.
- **`skill_tree_database.dart` (✅ 완료):** 4대 클래스(Guardian, Sage, Ranger, Warrior)의 모든 스킬 트리, 필요 재료/TP, 보상 등을 정의. 스킬 검색 및 필터링 메서드 제공.
- **`item_database.dart` (✅ 완료):** 모든 '장비 아이템'(목걸이, 배지, 장난감, 간식)의 능력치, 장착 부위, 등급 등을 정의. ID 기반 아이템 조회 기능.
- **`material_database.dart` (✅ 완료):** 모든 '훈련 재료'(침착의 조각, 용기의 뼈 등)의 정보, 희귀도, 설명을 정의. 재료 ID 기반 조회 기능.
- **`dog_breeds.dart` (✅ 완료):** 강아지 품종 목록과 각 품종별 특성 정보를 정의.

### 📂 /models
**역할:** Firestore 데이터 구조 및 게임 내 객체를 정의하는 Dart 클래스.
- **`dog_model.dart` (✅ 완료):** 반려견의 모든 정보를 담는 핵심 모델
  - 설문 데이터 (guardianInfo, dogBasicInfo, dogHealthInfo, dogRoutine, problemBehaviors, trainingGoals)
  - 게임 시스템 (dogClass, trainingPoints, skills, inventory, equippedItems, trainingEnergy)
  - Firestore 직렬화/역직렬화 메서드 (`fromFirestore`, `toFirestore`)
  - 편의 메서드 (name, breed getter, copyWith)

- **`skill_model.dart` (✅ 완료):** 스킬의 속성을 정의
  - 클래스 타입, 필요 재료/TP, 태그, 설명
  - 스킬 클래스 열거형 (SkillClassType) 정의

- **`item_model.dart` (✅ 완료):** 장비 아이템의 속성을 정의
  - 아이템 이름, 설명, 능력치, 장착 슬롯
  - 아이템 슬롯 열거형 (ItemSlot) 정의

- **`material_model.dart` (✅ 완료):** 훈련 재료의 속성 정의
  - 재료 이름, 설명, 희귀도, 아이콘 정보

- **`quest_model.dart` (✅ 완료):** AI 생성 퀘스트의 구조 정의
  - 제목, 설명, 보상 TP, 보상 재료, 연관 스킬 ID
  - JSON 직렬화 메서드 (`fromJson`)

- **`user_model.dart` (✅ 완료):** 사용자 정보 모델
  - uid, email, displayName, role, 트레이너 관계 정보
  - Firestore 직렬화/역직렬화 지원

- **`training_plan_model.dart` (✅ 완료):** 훈련 계획 모델 (향후 트레이너 기능용)
  - 계획 ID, 사용자-강아지-트레이너 관계, 주간 계획, 상태 관리

- **`training_result_model.dart` (✅ 완료):** 훈련 세션 결과 모델
  - 성공 여부, 성공 횟수, 최대 콤보, 연관 퀘스트 정보

- **`survey_model.dart` (✅ 완료):** 설문 응답 데이터 모델
  - 설문 각 단계별 데이터 구조 정의

### 📂 /screens

#### 📂 /my_dogs
- **`my_dogs_page.dart` (✅ 완료):** 사용자의 모든 반려견 '디지털 신분증' 메인 화면
  - DogService.getDogs() 스트림으로 실시간 강아지 목록 표시
  - PageView 기반 카드 스와이프 인터페이스
  - 신규 강아지 등록 버튼 (+)
  - 각 강아지별 편집/스킬트리/인벤토리/훈련 네비게이션
  - 상세 로그 출력으로 데이터 로딩 과정 추적

#### 📂 /training
- **`training_page.dart` (✅ 완료):** AIService가 생성한 퀘스트 목록을 보여주는 '퀘스트 보드'
  - 실제 AIService와 MockAIService 전환 가능
  - QuestCardWidget으로 퀘스트 목록 표시
  - 퀘스트 선택 시 QuestDetailScreen으로 이동

- **`quest_detail_screen.dart` (✅ 완료):** '몬스터 헌터 작전 브리핑' 컨셉의 퀘스트 상세 화면
  - 몽고서 컨셉의 브리핑 UI (핀으로 고정된 양피지 스타일)
  - 퀘스트 제목, 설명, 예상 보상 재료 표시
  - "퀘스트 수주!" 버튼으로 TrainingSessionScreen 이동

- **`training_session_screen.dart` (✅ 완료):** 'RPG 전투 화면' 컨셉의 인터랙티브 훈련 미니게임
  - 실시간 기력(Stamina) 바 및 감소 시스템
  - 성공 카운터 및 콤보 체인 시스템
  - 마법진 스타일의 TAP 인터랙션
  - 쿨다운 애니메이션 및 일시정지 기능
  - 성공/실패에 따른 LogSessionScreen 이동

- **`log_session_screen.dart` (✅ 완료):** '전리품 정산' 화면
  - 훈련 성공/실패 결과 표시
  - 획득 재료 목록 및 TP 정보
  - 한 줄 훈련 일지 입력 기능
  - 제작 가능한 스킬 확인 로직
  - DogService.completeTrainingSession 호출 (백엔드 연동)

- **`skill_tree_page.dart` (✅ 완료):** 클래스를 선택하고 스킬을 '제작'하는 화면
  - 4대 클래스 선택 UI
  - 선택된 클래스별 스킬 트리 표시
  - 재료 및 TP 요구사항 확인
  - 스킬 학습 기능

- **`inventory_page.dart` (✅ 완료):** 획득한 아이템과 재료를 확인하고 장비를 장착하는 화면
  - 탭 기반 인터페이스 (재료/아이템 분리)
  - 보유 재료 및 수량 표시
  - 장비 아이템 장착/해제 기능
  - 아이템 상세 정보 표시

#### 📂 /survey
- **`survey_screen.dart` (✅ 완료):** 반려견 프로필 입력/수정 메인 화면
  - PageView 기반 다단계 설문 인터페이스
  - SurveyProvider와 연동하여 데이터 관리
  - 신규 등록 및 기존 데이터 수정 모드 지원
  - 진행률 표시 및 단계별 네비게이션

- **`survey_page_widget.dart` (✅ 완료):** 설문 각 페이지의 공통 레이아웃 위젯

##### 📂 /pages
- **`guardian_info_page.dart` (✅ 완료):** 보호자 정보 입력 페이지
- **`training_goals_page.dart` (✅ 완료):** 훈련 목표 및 투자 가능 시간 설정
- **`problem_behaviors_page.dart` (✅ 완료):** 문제 행동 체크리스트
- **`dog_routine_page.dart` (✅ 완료):** 강아지 일상 루틴 정보

##### 📂 /dog_info (하위 페이지들)
- 강아지 기본 정보 및 건강 정보 관련 세부 페이지들

### 📂 /services
**역할:** Firebase와의 통신 등 백엔드 로직을 처리하는 서비스 계층.

- **`auth_service.dart` (✅ 완료):** 사용자 인증 서비스
  - Firebase Auth 기반 익명 로그인 및 Google 로그인
  - 인증 상태 변화 스트림 제공
  - 자동 Firestore 사용자 문서 생성
  - ChangeNotifier로 상태 변화 알림

- **`dog_service.dart` (✅ 완료):** 강아지 데이터 및 게임 로직 핵심 서비스
  - Firestore CRUD: `addDog`, `updateDog`, `getDogs` (실시간 스트림)
  - 게임 로직: `chooseDogClass`, `learnSkill`, `completeTrainingSession`
  - 사용자별 강아지 컬렉션 관리
  - 상세 디버그 로그 출력으로 데이터 흐름 추적
  - 인증 에러 및 데이터 검증 처리

- **`ai_service.dart` (✅ 완료):** AI 기반 퀘스트 생성 서비스
  - Firebase VertexAI (Gemini) 모델 연동
  - Dog 프로필 분석 및 맞춤형 프롬프트 생성
  - JSON 응답 파싱 및 Quest 객체 변환
  - 스킬 트리 태그 기반 퀘스트 분류
  - 에러 처리 및 로그 출력

- **`mock_ai_service.dart` (✅ 완료):** AI 서비스 목업 구현
  - 미리 정의된 퀘스트 템플릿 제공
  - 네트워크 지연 시뮬레이션
  - UI 개발 및 테스트용 안정적인 데이터 제공
  - 실제 AI 호출 없이도 전체 플로우 테스트 가능

### 📂 /providers
- **`survey_provider.dart` (✅ 완료):** 설문 상태 관리 프로바이더
  - 다단계 설문 데이터 임시 저장 및 관리
  - DogService와 연동하여 최종 데이터 저장
  - 로딩 상태 및 에러 처리
  - 신규 생성 및 편집 모드 지원

### 📂 /widgets
**역할:** 여러 화면에서 재사용되는 공통 UI 컴포넌트.

- **`dog_id_card_widget.dart` (✅ 완료):** 핵심 '캐릭터 정보창' 위젯
  - 반려견 프로필 완성도 기반 레벨 계산
  - 클래스, 장비, 스킬 정보 종합 표시
  - 게임 스타일 UI (픽셀 폰트, 테두리, 그림자)
  - 편집/스킬트리/인벤토리/훈련 버튼 제공
  - 동적 스킬 표시 (상위 4개 스킬)

- **`quest_card_widget.dart` (✅ 완료):** 퀘스트 목록용 카드 위젯
  - 몽고서/판타지 컨셉 디자인 (갈색 배경, 금색 텍스트)
  - 퀘스트 난이도 별표 표시 (TP 기반)
  - 보상 TP 및 재료 칩 형태로 표시
  - 탭 이벤트 처리

---

## 5. 데이터 흐름 및 상태 관리

### 인증 흐름
1. `main.dart` → `AuthWrapper` → 인증 상태에 따라 `LoginPage` 또는 `HomePage` 표시
2. `LoginPage` → `AuthService.signInAnonymously()` → Firestore 사용자 문서 자동 생성
3. 인증 상태 변화 시 자동으로 메인 화면 전환

### 강아지 데이터 흐름
1. `MyDogsPage` → `DogService.getDogs()` 스트림 → 실시간 강아지 목록 표시
2. `SurveyScreen` → `SurveyProvider` → `DogService.addDog/updateDog` → Firestore 저장
3. 모든 강아지 관련 화면에서 동일한 `DogService` 인스턴스 사용

### 훈련/퀘스트 흐름
1. `TrainingPage` → `AIService.generateQuests()` → AI 기반 퀘스트 생성
2. `QuestDetailScreen` → `TrainingSessionScreen` → `LogSessionScreen`
3. `LogSessionScreen` → `DogService.completeTrainingSession()` → 보상 지급 및 로그 저장

### 스킬/아이템 시스템
1. 정적 데이터 (`/data`) → 게임 규칙 정의
2. `DogService` → 스킬 학습 및 아이템 장착 로직
3. UI 화면 → 사용자 인터랙션 → 백엔드 서비스 호출

---

## 6. 개발 상태 요약

### ✅ 완료된 기능
- 사용자 인증 (익명 로그인)
- 강아지 프로필 등록/편집 (다단계 설문)
- 실시간 강아지 목록 표시
- AI 기반 퀘스트 생성
- 완전한 훈련 플로우 (퀘스트 보드 → 상세 → 세션 → 결과)
- 스킬 트리 및 인벤토리 시스템
- Firebase Firestore 기반 데이터 저장

### 🔄 진행 중인 기능
- 훈련 결과 백엔드 로직 완성 (DogService.completeTrainingSession)
- 보상 지급 및 스킬 제작 연동

### 📋 향후 계획
- 온디바이스 AI 모델 전환 (mediapipe_genai)
- GPS 기반 산책 챌린지
- 실제 Google 로그인 활성화
- 트레이너-보호자 연결 시스템
