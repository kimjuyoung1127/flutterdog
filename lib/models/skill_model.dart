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
  // Defines rewards at specific levels, e.g., {3: "item_id_1", 5: "item_id_2"}
  final Map<int, String> milestoneRewards; 

  const Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.classType,
    required this.subTree,
    required this.requiredTp,
    this.maxLevel = 5, // Default max level for most skills
    this.milestoneRewards = const {},
  });
}
