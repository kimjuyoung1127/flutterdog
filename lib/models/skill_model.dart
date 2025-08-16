enum SkillClassType { guardian, sage, ranger, warrior }
enum SkillSubTree { guardiansOath, knightsDiscipline, pathOfSerenity, innerFortress, animalBond, pathfindersArt, physicalConditioning, combatFinesse }

class Skill {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final SkillClassType classType;
  final SkillSubTree subTree;
  // Both TP and Materials are now required to learn a skill.
  final int requiredTp;
  final Map<String, int> craftingMaterials;
  final int maxLevel;
  final Map<int, String> milestoneRewards; 
  final List<String> tags;

  const Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.classType,
    required this.subTree,
    this.requiredTp = 0,
    this.craftingMaterials = const {},
    this.maxLevel = 5,
    this.milestoneRewards = const {},
    this.tags = const [],
  });
}
