enum SkillClassType { guardian, sage, ranger, warrior }
enum SkillSubTree { guardiansOath, knightsDiscipline, pathOfSerenity, innerFortress, animalBond, pathfindersArt, physicalConditioning, combatFinesse }

class Skill {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final SkillClassType classType;
  final SkillSubTree subTree;
  final int requiredTp;
  final int maxLevel;
  final Map<int, String> milestoneRewards; 
  final List<String> tags; // New field for AI matching

  const Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.classType,
    required this.subTree,
    required this.requiredTp,
    this.maxLevel = 5,
    this.milestoneRewards = const {},
    this.tags = const [], // Initialize with an empty list
  });
}
