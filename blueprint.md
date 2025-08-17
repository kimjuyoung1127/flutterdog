# 반려견 성장 파트너 앱 설계도 (v6.0)

**최종 수정:** 2025년 8월 26일

**핵심 방향:** Gemma 3 270M 온디바이스 AI 이식 및 'Mock-First' 개발 워크플로우 도입

## 1. 개요
이 문서는 '반려견 성장 파트너' 앱의 AI 시스템을 **서버 기반(Gemini)에서 온디바이스(Gemma 3 270M)로 전환**하고, 이를 위한 **'Mock-First 하이브리드 워크플로우'**를 도입하는 것을 목표로 하는 최상위 기획 문서입니다.

## 2. Mock-First 하이브리드 워크플로우
1.  **Phase 0: 로컬 AI 프롬프트 검증:** LM Studio 등의 도구를 사용하여, Gemma 3 270M 모델이 우리의 프롬프트에 원하는 JSON 형식의 응답을 생성하는지 독립적으로 테스트하고 최적화합니다.
2.  **Phase 1: Firebase Studio (UI & Mocking):**
    -   **'MockAIService'**를 사용하여 실제 AI 모델 없이 가짜 데이터로 모든 UI(TrainingPage, QuestCard 등)와 기본 로직을 90% 완성합니다.
    -   이를 통해 Firebase Studio의 빠른 개발 속도를 극대화합니다.
3.  **Phase 2: 로컬 환경 (실제 모델 이식):**
    -   UI 개발이 완료되면, 로컬 환경(Android Studio 등)으로 코드를 가져옵니다.
    -   `mediapipe_genai`와 같은 패키지를 사용하여 실제 Gemma 3 270M 모델 파일을 앱에 이식하고, `AIService`가 실제 모델을 호출하도록 최종 연결합니다.
    -   실제 휴대폰에서 최종 테스트 및 디버깅을 진행합니다.

## 3. 핵심 게임 루프 (Core Game Loop)
1.  **퀘스트 수주 (`TrainingPage`):** AI가 생성한 훈련 퀘스트를 '퀘스트 보드'에서 선택합니다.
2.  **훈련 (`TrainingSessionScreen`):** '인터랙티브 훈련 챌린지' 미니 게임을 통해 훈련을 수행합니다.
3.  **결과 정산 (`LogSessionScreen`):** 훈련 결과를 확인하고, 보상으로 **'훈련 포인트(TP)'와 '훈련 재료'**를 얻습니다.
4.  **성장 (`SkillTreePage` / `InventoryPage`):** 획득한 TP와 재료를 소모하여 스킬을 배우거나 장비를 제작/장착합니다.
5.  **확인 (`MyDogsPage`):** '디지털 신분증'(`DogIdCardWidget`)에서 반려견의 성장을 확인합니다.

## 4. 개발 계획 (Development Plan)

### 1순위: '인터랙티브 훈련 챌린지' UI 흐름 완성 - ✅ 완료
- **`QuestDetailScreen` 개발:** '몬스터 헌터 작전 브리핑' 컨셉의 UI를 완성했습니다.
- **`TrainingSessionScreen` 개발:** 'RPG 전투 화면' 컨셉의 미니 게임 UI 및 핵심 로직을 완성했습니다.
- **`LogSessionScreen` 프로토타입 개발:** '전리품 정산' 화면의 UI 프로토타입을 완성했습니다.
- **네비게이션 연결:** `TrainingPage` -> `QuestDetailScreen` -> `TrainingSessionScreen`으로 이어지는 전체 UI 흐름을 완벽하게 연결했습니다.

### 2순위: `LogSessionScreen` 백엔드 로직 구현 - ⏳ 진행 중
- **다음 작업:** `LogSessionScreen`의 "훈련 완료" 버튼을 눌렀을 때, 훈련 보상(TP/재료) 지급, '한 줄 일지' 저장, '훈련 에너지' 소모 등 모든 백엔드 로직을 `DogService`에 구현하고 연결합니다.

### 3순위: 온디바이스 AI 전환 (Phase 2: 실제 모델 이식)
- `mediapipe_genai` 패키지 추가 및 네이티브 설정을 진행합니다.
- `AIService`가 실제 `assets` 폴더의 Gemma 모델을 호출하도록 로직을 수정합니다.

### 4순위 (장기 비전): GPS 기반 '산책 챌린지'
- 온디바이스 AI 시스템이 안정화된 후, GPS를 활용한 최종 콘텐츠를 구현합니다.
