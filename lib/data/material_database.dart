import 'package:myapp/models/material_model.dart';

// This file acts as a local, static database for all crafting/training materials.
class MaterialDatabase {
  static final Map<String, Material> materials = {
    // --- Common Materials ---
    'mat_courage_bone': const Material(
      id: 'mat_courage_bone',
      name: '용기의 뼈',
      description: '기초적인 훈련을 통해 얻을 수 있는 단단한 뼈. 자신감을 불어넣어 준다.',
      iconAsset: 'assets/icons/materials/bone.png',
    ),
    'mat_calmness_fragment': const Material(
      id: 'mat_calmness_fragment',
      name: '평온의 파편',
      description: '집중력 훈련을 통해 얻는 반짝이는 파편. 마음을 차분하게 가라앉힌다.',
      iconAsset: 'assets/icons/materials/fragment.png',
    ),

    // --- Guardian Class Materials ---
    'mat_guardian_emblem': const Material(
      id: 'mat_guardian_emblem',
      name: '수호자의 증표',
      description: '수호자 클래스의 고급 훈련을 통해 얻을 수 있는 증표.',
      iconAsset: 'assets/icons/materials/guardian_emblem.png',
    ),
    
    // ... other materials for all classes will be added here ...
  };

  static Material? getMaterialById(String id) {
    return materials[id];
  }
}
