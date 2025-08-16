import 'package:myapp/models/skill_model.dart';

// This file acts as a local, static database for all skills available in the game.

class SkillTreeDatabase {
  static final Map<String, Skill> skills = {
    // === 🛡️ GUARDIAN CLASS ===
    // --- Guardian's Oath Sub-Tree ---
    'guardian_house_training': const Skill(
      id: 'guardian_house_training',
      name: '하우스 적응',
      description: '자신의 공간에 편안함을 느끼고 안정적으로 머무는 능력을 향상시킵니다.',
      iconAsset: 'assets/icons/skills/guardian_house.png',
      classType: SkillClassType.guardian,
      subTree: SkillSubTree.guardiansOath,
      requiredTp: 1,
      milestoneRewards: {3: 'item_fluffy_cushion'},
    ),
    'guardian_potty_training': const Skill(
      id: 'guardian_potty_training',
      name: '배변 훈련',
      description: '지정된 장소에서 배변하는 능력을 완벽하게 습득합니다.',
      iconAsset: 'assets/icons/skills/guardian_potty.png',
      classType: SkillClassType.guardian,
      subTree: SkillSubTree.guardiansOath,
      requiredTp: 2,
      milestoneRewards: {5: 'item_golden_pad'},
    ),
    'guardian_bite_inhibition': const Skill(
      id: 'guardian_bite_inhibition',
      name: '입질 교육',
      description: '보호자의 손이나 물건을 무는 행동을 제어하는 능력을 배웁니다.',
      iconAsset: 'assets/icons/skills/guardian_bite.png',
      classType: SkillClassType.guardian,
      subTree: SkillSubTree.guardiansOath,
      requiredTp: 2,
      milestoneRewards: {3: 'item_tug_toy'},
    ),
    // --- Knight's Discipline Sub-Tree ---
     'guardian_leash_manners': const Skill(
      id: 'guardian_leash_manners',
      name: '산책 예절',
      description: '산책 시 흥분하지 않고 보호자와 보폭을 맞추어 걷습니다.',
      iconAsset: 'assets/icons/skills/guardian_leash.png',
      classType: SkillClassType.guardian,
      subTree: SkillSubTree.knightsDiscipline,
      requiredTp: 3,
      milestoneRewards: {5: 'item_sturdy_harness'},
    ),
    // ... other skills will be added here following the same structure ...
  };

  // Helper function to get all skills for a specific class
  static List<Skill> getSkillsByClass(SkillClassType classType) {
    return skills.values.where((skill) => skill.classType == classType).toList();
  }
}
