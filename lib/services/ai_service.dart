import 'dart:convert';
// 1. 올바른 패키지 이름으로 수정
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/data/skill_tree_database.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/quest_model.dart';
import 'package:myapp/models/skill_model.dart';

class AIService {
  // 1. 올바른 클래스 이름으로 수정
  final _model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-1.5-flash-latest',
    systemInstruction: Content.system(
      "You are a positive, creative, and game-focused professional dog trainer. Your goal is to analyze a dog's profile and generate 3 personalized training quests in the style of an RPG. You must respond ONLY with a valid JSON array of quest objects. Do not include any explanatory text before or after the JSON array."
    ),
  );

  /// Generates personalized training quests by combining AI creativity with local business logic.
  Future<List<Quest>> generateQuests({required Dog dog}) async {
    final prompt = _createPromptFromDog(dog);
    final response = await _model.generateContent([Content.text(prompt)]);
    final responseText = response.text;

    if (responseText == null || responseText.isEmpty) {
      throw Exception('AI model returned an empty response.');
    }
    debugPrint("AI Raw Response: $responseText");

    try {
      final cleanedJson = _cleanJsonString(responseText);
      final List<dynamic> jsonList = jsonDecode(cleanedJson);
      
      return jsonList.map((json) {
        final aiTitle = json['title'] as String? ?? 'Unknown Quest';
        final aiDescription = json['description'] as String? ?? 'No description.';
        final aiTag = json['tag'] as String? ?? 'general'; // Corrected from skillTag to tag
        final skill = _findSkillByTag(aiTag);
        
        return Quest(
          title: aiTitle,
          description: aiDescription,
          rewardTp: skill.requiredTp, 
          rewardSkillId: skill.id, 
        );
      }).toList();

    } catch (e) {
      debugPrint("JSON Parsing or Quest Finalizing Error: $e");
      throw Exception('Failed to process AI response.');
    }
  }

  /// Creates a detailed prompt for the AI based on the dog's profile.
  String _createPromptFromDog(Dog dog) {
    final goals = dog.trainingGoals.isNotEmpty ? dog.trainingGoals.keys.join(', ') : 'Not specified';
    final behaviors = dog.problemBehaviors.isNotEmpty ? dog.problemBehaviors.keys.join(', ') : 'Not specified';
    final availableTags = SkillTreeDatabase.skills.values.expand((s) => s.tags).toSet().join(', ');

    final profileSummary = """
    Analyze the following dog's RPG profile:
    - Name: ${dog.name}
    - Class: ${dog.dogClass ?? 'Novice'}
    - Key Training Goals: $goals
    - Key Problem Behaviors: $behaviors
    """;

    final instructions = """
    Based on this profile, generate 3 creative and RPG-themed training quests.
    The result must be a single, valid JSON array. Each object must have these keys:
    - "title" (String): A short, fun, RPG-style name for the quest (e.g., "The Trial of Patience").
    - "description" (String): A 1-2 sentence, clear, and positive action plan for the owner.
    - "tag" (String): The single most relevant skill tag for this quest. You MUST choose one tag from this list: [$availableTags].
    """;

    return '$profileSummary\n\n$instructions';
  }

  /// Finds a skill from the local database that best matches the tag provided by the AI.
  Skill _findSkillByTag(String tag) {
    for (var skill in SkillTreeDatabase.skills.values) {
      if (skill.tags.contains(tag.toLowerCase())) {
        return skill;
      }
    }
    return SkillTreeDatabase.skills['common_basic_training']!; 
  }

  /// Cleans the raw text from the AI to make it a valid JSON string.
  String _cleanJsonString(String rawJson) {
    final startIndex = rawJson.indexOf('[');
    final endIndex = rawJson.lastIndexOf(']');
    // 2. 올바른 비교 연산자로 수정
    if (startIndex != -1 && endIndex != -1) {
      return rawJson.substring(startIndex, endIndex + 1);
    }
    return rawJson;
  }
}
