import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel {
  final String surveyId;
  final String userId;
  final String dogId;
  final Map<String, dynamic> guardianInfo;
  final Map<String, dynamic> dogBasicInfo; // New field
  final Map<String, dynamic> dogHealthInfo; // New field
  final Map<String, dynamic> dogRoutine;
  final Map<String, dynamic> problemBehaviors;
  final Map<String, dynamic> trainingGoals;
  final Timestamp createdAt;

  SurveyModel({
    required this.surveyId,
    required this.userId,
    required this.dogId,
    required this.guardianInfo,
    required this.dogBasicInfo,
    required this.dogHealthInfo,
    required this.dogRoutine,
    required this.problemBehaviors,
    required this.trainingGoals,
    required this.createdAt,
  });

  factory SurveyModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return SurveyModel(
      surveyId: snapshot.id,
      userId: data?['userId'] as String,
      dogId: data?['dogId'] as String,
      guardianInfo: data?['guardian_info'] as Map<String, dynamic>,
      dogBasicInfo: data?['dog_basic_info'] as Map<String, dynamic>,
      dogHealthInfo: data?['dog_health_info'] as Map<String, dynamic>,
      dogRoutine: data?['dog_routine'] as Map<String, dynamic>,
      problemBehaviors: data?['problem_behaviors'] as Map<String, dynamic>,
      trainingGoals: data?['training_goals'] as Map<String, dynamic>,
      createdAt: data?['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'dogId': dogId,
      'guardian_info': guardianInfo,
      'dog_basic_info': dogBasicInfo,
      'dog_health_info': dogHealthInfo,
      'dog_routine': dogRoutine,
      'problem_behaviors': problemBehaviors,
      'training_goals': trainingGoals,
      'createdAt': createdAt,
    };
  }
}
