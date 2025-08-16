import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingPlanModel {
  final String planId;
  final String userId;
  final String dogId;
  final String trainerId;
  final String ownerName;
  final String dogName;
  final Timestamp startDate;
  final Timestamp endDate;
  final bool generatedByAI;
  final String status;
  final List<Map<String, dynamic>> weeklyPlan;
  final String monthlySummary;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  TrainingPlanModel({
    required this.planId,
    required this.userId,
    required this.dogId,
    required this.trainerId,
    required this.ownerName,
    required this.dogName,
    required this.startDate,
    required this.endDate,
    required this.generatedByAI,
    required this.status,
    required this.weeklyPlan,
    required this.monthlySummary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrainingPlanModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return TrainingPlanModel(
      planId: snapshot.id,
      userId: data?['userId'] as String,
      dogId: data?['dogId'] as String,
      trainerId: data?['trainerId'] as String,
      ownerName: data?['ownerName'] as String,
      dogName: data?['dogName'] as String,
      startDate: data?['startDate'] as Timestamp,
      endDate: data?['endDate'] as Timestamp,
      generatedByAI: data?['generatedByAI'] as bool,
      status: data?['status'] as String,
      weeklyPlan: List<Map<String, dynamic>>.from(data?['weekly_plan'] as List),
      monthlySummary: data?['monthly_summary'] as String,
      createdAt: data?['createdAt'] as Timestamp,
      updatedAt: data?['updatedAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'dogId': dogId,
      'trainerId': trainerId,
      'ownerName': ownerName,
      'dogName': dogName,
      'startDate': startDate,
      'endDate': endDate,
      'generatedByAI': generatedByAI,
      'status': status,
      'weekly_plan': weeklyPlan,
      'monthly_summary': monthlySummary,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
