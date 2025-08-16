class Quest {
  final String title;
  final String description;
  // rewardTp is replaced by rewardMaterials
  final Map<String, int> rewardMaterials; // e.g., {'mat_courage_bone': 3}
  final String rewardSkillId; 

  Quest({
    required this.title,
    required this.description,
    required this.rewardMaterials,
    required this.rewardSkillId,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      title: json['title'] as String,
      description: json['description'] as String,
      // Safely parse the map from JSON
      rewardMaterials: Map<String, int>.from(json['rewardMaterials'] as Map? ?? {}),
      rewardSkillId: json['rewardSkillId'] as String,
    );
  }
}
