enum SkillClassType { guardian, sage, ranger, warrior }
enum SkillSubTree { guardiansOath, knightsDiscipline, pathOfSerenity, innerFortress, animalBond, pathfindersArt, physicalConditioning, combatFinesse }

class Skill {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final SkillClassType classType;
  final SkillSubTree subTree;
  // requiredTp is replaced by craftingMaterials
  final Map<String, int> craftingMaterials; // e.g., {'mat_courage_bone': 5, 'mat_calmness_fragment': 3}
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
    this.craftingMaterials = const {}, // Initialize with an empty map
    this.maxLevel = 5,
    this.milestoneRewards = const {},
    this.tags = const [],
  });
}
