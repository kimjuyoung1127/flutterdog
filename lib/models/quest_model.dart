class Quest {
  final String title;
  final String description;
  final int rewardTp; // Training Points rewarded for completing the quest
  final String rewardSkillId; // The ID of the skill that gets experience

  Quest({
    required this.title,
    required this.description,
    required this.rewardTp,
    required this.rewardSkillId,
  });

  // Factory constructor to create a Quest from a JSON map
  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      title: json['title'] as String,
      description: json['description'] as String,
      rewardTp: json['rewardTp'] as int,
      rewardSkillId: json['rewardSkillId'] as String,
    );
  }
}
