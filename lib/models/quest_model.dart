class Quest {
  final String title;
  final String description;
  final int rewardTp;
  final Map<String, int> rewardMaterials;
  final String rewardSkillId; 

  Quest({
    required this.title,
    required this.description,
    this.rewardTp = 0,
    this.rewardMaterials = const {},
    required this.rewardSkillId,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      title: json['title'] as String? ?? 'Unnamed Quest',
      description: json['description'] as String? ?? 'No description.',
      rewardTp: json['rewardTp'] as int? ?? 0,
      rewardMaterials: Map<String, int>.from(json['rewardMaterials'] as Map? ?? {}),
      rewardSkillId: json['rewardSkillId'] as String? ?? 'common_basic_training',
    );
  }
}
