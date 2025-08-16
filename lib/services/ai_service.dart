import 'dart:convert';
// Corrected: Import the package that is actually listed in pubspec.yaml
import 'package:firebase_vertexai/firebase_vertexai.dart'; 
import 'package:flutter/foundation.dart';
import 'package:myapp/data/skill_tree_database.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/quest_model.dart';
import 'package:myapp/models/skill_model.dart';

class AIService {
  // This class name is correct for the 'firebase_vertexai' package.
  final _model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-1.5-flash-latest',
    systemInstruction: Content.system(
      "You are a positive and creative professional dog trainer specializing in RPG-style quests. Your goal is to analyze a dog's profile and generate 3 personalized training quests. You must respond ONLY with a valid JSON array of quest objects. Each object must contain a 'title', 'description', and a 'tag'."
    ),
  );

  /// Generates personalized training quests by combining AI creativity with local business logic.
  Future<List<Quest>> generateQuests({required Dog dog}) async {
    final prompt = _createPromptFromDog(dog);
    // The Content class is also correctly exposed by the 'firebase_vertexai' package.
    final response = await _model.generateContent([Content.text(prompt)]);
    final responseText = response.text;

    if (responseText == null || responseText.isEmpty) {
      throw Exception('AI model returned an empty response.');
    }
    debugPrint("AI Raw Response: $responseText");

    try {
      final cleanedJson = _cleanJsonString(responseText);
      final List<dynamic> jsonList = jsonDecode(cleanedJson);
      
      final List<Quest> quests = [];
      for (var jsonQuest in jsonList) {
        final aiTitle = jsonQuest['title'] as String;
        final aiDescription = jsonQuest['description'] as String;
        final aiTag = jsonQuest['tag'] as String;

        final Skill matchedSkill = _findSkillByTag(aiTag);

        quests.add(Quest(
          title: aiTitle,
          description: aiDescription,
          rewardTp: matchedSkill.requiredTp, // This will be fixed in the next step
          rewardSkillId: matchedSkill.id,
        ));
      }
      return quests;

    } catch (e) {
      debugPrint("JSON Parsing or Quest Finalizing Error: $e");
      throw Exception('Failed to process AI response.');
    }
  }

  Skill _findSkillByTag(String tag) {
    for (var skill in SkillTreeDatabase.skills.values) {
      if (skill.tags.contains(tag.toLowerCase())) {
        return skill;
      }
    }
    debugPrint("Warning: AI generated a tag '$tag' that didn't match any skill. Falling back to default.");
    return SkillTreeDatabase.skills['common_basic_training']!;
  }

  String _createPromptFromDog(Dog dog) {
    final goals = dog.trainingGoals.isNotEmpty ? dog.trainingGoals.keys.join(', ') : 'Not specified';
    final behaviors = dog.problemBehaviors.isNotEmpty ? dog.problemBehaviors.keys.join(', ') : 'Not specified';
    
    final allTags = SkillTreeDatabase.skills.values.expand((skill) => skill.tags).toSet().toList();

    final profileSummary = "Analyze the following dog's RPG profile:\n- Name: ${dog.name}\n- Class: ${dog.dogClass ?? 'Not chosen yet'}\n- Key Training Goals: $goals\n- Key Problem Behaviors: $behaviors";

    final instructions = """
    Based on this profile, generate 3 creative and RPG-themed training quests.
    The result must be a single, valid JSON array. Each JSON object must have these exact keys and data types:
    - "title" (String): A short, fun, and engaging name for the quest.
    - "description" (String): A 1-2 sentence, clear, and positive action plan for the owner to follow.
    - "tag" (String): The single most relevant skill tag for this quest. You MUST choose ONE tag from the following list: ${allTags.join(', ')}
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
