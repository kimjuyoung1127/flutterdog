import 'dart:math';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/quest_model.dart';

/// A mock implementation of the AI service for UI development and testing.
/// This service returns pre-defined or randomly generated quests without calling any real AI.
class MockAIService {
  final Random _random = Random();

  // A list of pre-defined quest templates for mocking.
  final List<Map<String, dynamic>> _mockQuestTemplates = [
    {
      "title": "고요의 시험",
      "description": "보호자가 현관문을 나갔다 들어올 때, 짖지 않고 차분하게 기다리는 훈련을 5분간 진행합니다.",
      "rewardTp": 20,
      "rewardMaterials": {"mat_calmness_fragment": 1},
      "rewardSkillId": "guardian_bite_inhibition" // Placeholder
    },
    {
      "title": "끈기의 미로",
      "description": "산책 중 다른 강아지를 마주쳤을 때, 줄을 당기지 않고 보호자 옆에 머무는 연습을 합니다.",
      "rewardTp": 30,
      "rewardMaterials": {"mat_courage_bone": 2},
      "rewardSkillId": "guardian_leash_manners"
    },
    {
      "title": "집중의 눈맞춤",
      "description": "장난감의 유혹 속에서, '앉아' 명령어와 함께 보호자와 3초간 눈을 맞추는 연습을 합니다.",
      "rewardTp": 15,
      "rewardMaterials": {"mat_calmness_fragment": 2},
      "rewardSkillId": "common_basic_training"
    },
    {
      "title": "환영의 의식",
      "description": "집에 손님이 방문했을 때, 점프하지 않고 앉아서 인사하는 예절을 배웁니다.",
      "rewardTp": 40,
      "rewardMaterials": {"mat_guardian_emblem": 1},
      "rewardSkillId": "guardian_leash_manners" // Placeholder
    }
  ];

  /// Returns a list of 3 random mock quests.
  Future<List<Quest>> generateQuests({required Dog dog}) async {
    // Simulate a network delay to test loading indicators.
    await Future.delayed(const Duration(seconds: 1));

    // Shuffle the templates and take the first 3.
    final shuffled = List.of(_mockQuestTemplates)..shuffle(_random);
    final selectedQuests = shuffled.take(3);

    return selectedQuests.map((json) => Quest.fromJson(json)).toList();
  }
}
