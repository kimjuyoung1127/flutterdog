import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/data/skill_tree_database.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/quest_model.dart';
import 'package:myapp/models/skill_model.dart';

class AIService {
  final _model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-1.5-flash-latest',
    systemInstruction: Content.system(
      // Updated instruction for the AI
      "You are a positive and creative professional dog trainer specializing in RPG-style quests. Your goal is to analyze a dog's profile and generate 3 personalized training quests. You must respond ONLY with a valid JSON array of quest objects. Each object must contain 'title', 'description', 'tag', and 'rewardMaterials'."
    ),
  );

  Future<List<Quest>> generateQuests({required Dog dog}) async {
    final prompt = _createPromptFromDog(dog);
    final response = await _model.generateContent([Content.text(prompt)]);
    final responseText = response.text;

    if (responseText == null || responseText.isEmpty) {
      throw Exception('AI model returned an empty response.');
    }
    
    try {
      final cleanedJson = _cleanJsonString(responseText);
      final List<dynamic> jsonList = jsonDecode(cleanedJson);
      
      final List<Quest> quests = [];
      for (var jsonQuest in jsonList) {
        final aiTitle = jsonQuest['title'] as String;
        final aiDescription = jsonQuest['description'] as String;
        final aiTag = jsonQuest['tag'] as String;
        // AI now suggests the reward materials directly
        final aiRewardMaterials = Map<String, int>.from(jsonQuest['rewardMaterials'] as Map? ?? {});

        final Skill matchedSkill = _findSkillByTag(aiTag);

        quests.add(Quest(
          title: aiTitle,
          description: aiDescription,
          rewardMaterials: aiRewardMaterials, // Use the reward from AI
          rewardSkillId: matchedSkill.id,
        ));
      }
      return quests;

    } catch (e) {
      debugPrint("JSON Parsing or Quest Finalizing Error: $e");
      throw Exception('Failed to process AI response.');
    }
  }

  String _createPromptFromDog(Dog dog) {
    // ... prompt generation logic ...
    
    final instructions = """
    Based on this profile, generate 3 creative and RPG-themed training quests.
    The result must be a single, valid JSON array. Each object must have these exact keys and data types:
    - "title" (String): ...
    - "description" (String): ...
    - "tag" (String): ...
    - "rewardMaterials" (Map<String, int>): A map containing one or two relevant material IDs as keys and their quantity (1 to 3) as values. For example: {"mat_courage_bone": 2, "mat_calmness_fragment": 1}
    """;

    return '...'; // a placeholder for the full prompt
  }

  // ... other helper methods ...
}
