import 'package:myapp/models/skill_model.dart';

class SkillTreeDatabase {
  static final Map<String, Skill> skills = {
    'common_basic_training': const Skill(
      id: 'common_basic_training',
      name: '기초 훈련',
      description: '모든 성장의 기본이 되는 훈련입니다.',
      iconAsset: 'assets/icons/skills/common_book.png',
      classType: SkillClassType.guardian,
      subTree: SkillSubTree.guardiansOath,
      requiredTp: 10, // Base TP cost
      craftingMaterials: {'mat_courage_bone': 1},
      tags: ['basic', 'common'],
    ),

    'guardian_house_training': const Skill(
      id: 'guardian_house_training',
      name: '하우스 적응',
      description: '자신의 공간에 편안함을 느끼고 안정적으로 머무는 능력을 향상시킵니다.',
      iconAsset: 'assets/icons/skills/guardian_house.png',
      classType: SkillClassType.guardian,
      subTree: SkillSubTree.guardiansOath,
      requiredTp: 20,
      craftingMaterials: {'mat_calmness_fragment': 3},
      milestoneRewards: {3: 'item_fluffy_cushion'},
      tags: ['house', 'crate', 'place'],
    ),
    'guardian_potty_training': const Skill(
      id: 'guardian_potty_training',
      name: '배변 훈련',
      description: '지정된 장소에서 배변하는 능력을 완벽하게 습득합니다.',
      iconAsset: 'assets/icons/skills/guardian_potty.png',
      classType: SkillClassType.guardian,
      subTree: SkillSubTree.guardiansOath,
      requiredTp: 30,
      craftingMaterials: {'mat_calmness_fragment': 5},
      milestoneRewards: {5: 'item_golden_pad'},
      tags: ['potty', 'toilet', 'elimination'],
    ),
    'guardian_bite_inhibition': const Skill(
      id: 'guardian_bite_inhibition',
      name: '입질 교육',
      description: '보호자의 손이나 물건을 무는 행동을 제어하는 능력을 배웁니다.',
      iconAsset: 'assets/icons/skills/guardian_bite.png',
      classType: SkillClassType.guardian,
      subTree: SkillSubTree.guardiansOath,
      requiredTp: 25,
      craftingMaterials: {'mat_courage_bone': 3},
      milestoneRewards: {3: 'item_tug_toy'},
      tags: ['bite', 'mouthing', 'inhibition'],
    ),
     'guardian_leash_manners': const Skill(
      id: 'guardian_leash_manners',
      name: '산책 예절',
      description: '산책 시 흥분하지 않고 보호자와 보폭을 맞추어 걷습니다.',
      iconAsset: 'assets/icons/skills/guardian_leash.png',
      classType: SkillClassType.guardian,
      subTree: SkillSubTree.knightsDiscipline,
      requiredTp: 50,
      craftingMaterials: {'mat_courage_bone': 5, 'mat_guardian_emblem': 1},
      milestoneRewards: {5: 'item_sturdy_harness'},
      tags: ['leash', 'walking', 'manners', 'pulling'],
    ),
  };

  static List<Skill> getSkillsByClass(SkillClassType classType) {
    return skills.values.where((skill) => skill.classType == classType).toList();
  }
}
