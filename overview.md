# Pet Growth Partner: 프로젝트 아키텍처 개요 (Overview)

**최종 수정:** 2025년 8월 19일

## 1. 개요
... (내용 동일) ...
## 2. /lib 폴더 상세 구조
... (내용 동일) ...
### 📂 /data
- **역할:** 앱 전체에서 사용될 정적인 데이터 목록을 관리.
- **`skill_tree_database.dart` (✅ 완료):** 모든 `Skill` 정보를 정의.
- **`item_database.dart` (✅ 완료):** 모든 '장비 아이템' 정보를 정의.
- **`material_database.dart` (⏳ 진행 예정):** 모든 '훈련 재료' 정보를 정의.

### 📂 /models
- **역할:** Firestore 데이터 구조를 Dart 클래스로 변환하는 데이터 모델을 정의.
- **`dog_model.dart` (🔄 업데이트 필요):** `Dog` 클래스. `inventory` 타입을 `Map<String, int>`로 변경 필요.
- **`skill_model.dart` (✅ 완료):** `Skill` 클래스.
- **`item_model.dart` (✅ 완료):** '장비 아이템'을 위한 `Item` 클래스.
- **`material_model.dart` (⏳ 진행 예정):** '훈련 재료'를 위한 `Material` 클래스.
... (이하 내용 동일) ...
