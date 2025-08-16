import 'dart:convert';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/data/skill_tree_database.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/quest_model.dart';
// The 'skill_model.dart' import is removed as it's not directly used in this file.
// The 'Skill' type is inferred from the return type of methods in 'SkillTreeDatabase'.

class AIService {
  final _model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-1.5-flash-latest',
    systemInstruction: Content.system(
        "You are a positive and creative professional dog trainer specializing in RPG-style quests. Your goal is to analyze a dog's profile and generate 3 personalized training quests. You must respond ONLY with a valid JSON array of quest objects. Each object must contain 'title', 'description', 'rewardTp', 'rewardMaterials', and 'tag'."),
  );

  Future<List<Quest>> generateQuests({required Dog dog}) async {
    final prompt = _createPromptFromDog(dog);
    final response = await _model.generateContent([Content.text(prompt)]);

    if (response.text == null) {
      throw Exception('AI model returned no response.');
    }
    debugPrint("AI Raw Response: ${response.text}");

    try {
      final cleanedJson = _cleanJsonString(response.text!);
      final List<dynamic> jsonList = jsonDecode(cleanedJson);
      return jsonList.map((json) => Quest.fromJson(json)).toList();
    } catch (e) {
      debugPrint("JSON Parsing Error: $e");
      throw Exception('Failed to process AI response.');
    }
  }

  String _createPromptFromDog(Dog dog) {
    final allTags = SkillTreeDatabase.skills.values
        .expand((skill) => skill.tags)
        .toSet()
        .toList();
    const profileSummary = "Analyze the dog's profile...";
    final instructions = """
    Based on this profile, generate 3 quests.
    The result must be a single, valid JSON array. Each object must have these keys:
    - "title" (String): ...
    - "description" (String): ...
    - "rewardTp" (int): An integer between 10 and 50.
    - "rewardMaterials" (Map<String, int>): A map containing one relevant material ID (e.g. "mat_courage_bone") and its quantity (1 to 3).
    - "tag" (String): Choose ONE tag from this list: ${allTags.join(', ')}.
    """;
    return '$profileSummary\n\n$instructions';
  }

  String _cleanJsonString(String rawJson) {
    final startIndex = rawJson.indexOf('[');
    final endIndex = rawJson.lastIndexOf(']');
    if (startIndex != -1 && endIndex != -1) {
      return rawJson.substring(startIndex, endIndex + 1);
    }
    return rawJson;
  }
}
