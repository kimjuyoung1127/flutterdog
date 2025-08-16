import 'package:cloud_firestore/cloud_firestore.dart';

// Renamed from DogModel to Dog for simplicity and consistency
class Dog {
  final String? id; // Renamed from dogId to id for convention
  final String ownerId;
  
  // Survey parts remain as properties of the Dog model
  final Map<String, dynamic> guardianInfo;
  final Map<String, dynamic> dogBasicInfo;
  final Map<String, dynamic> dogHealthInfo;
  final Map<String, dynamic> dogRoutine;
  final Map<String, dynamic> problemBehaviors;
  final Map<String, dynamic> trainingGoals;

  Dog({
    this.id,
    required this.ownerId,
    this.guardianInfo = const {},
    this.dogBasicInfo = const {},
    this.dogHealthInfo = const {},
    this.dogRoutine = const {},
    this.problemBehaviors = const {},
    this.trainingGoals = const {},
  });

  // Helper getters for easier access to nested data
  String get name => dogBasicInfo['name'] as String? ?? 'Unnamed';
  String get breed => dogBasicInfo['breed'] as String? ?? 'Unknown Breed';
  // Example for a deeply nested property - ensure null safety
  String? get profileImageUrl => dogBasicInfo['profileImageUrl'] as String?;


  // Factory constructor to create a Dog instance from a Firestore document
  factory Dog.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Dog(
      id: snapshot.id,
      ownerId: data['ownerId'] as String,
      guardianInfo: data['guardianInfo'] as Map<String, dynamic>? ?? {},
      dogBasicInfo: data['dogBasicInfo'] as Map<String, dynamic>? ?? {},
      dogHealthInfo: data['dogHealthInfo'] as Map<String, dynamic>? ?? {},
      dogRoutine: data['dogRoutine'] as Map<String, dynamic>? ?? {},
      problemBehaviors: data['problemBehaviors'] as Map<String, dynamic>? ?? {},
      trainingGoals: data['trainingGoals'] as Map<String, dynamic>? ?? {},
    );
  }

  // Method to convert a Dog instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'guardianInfo': guardianInfo,
      'dogBasicInfo': dogBasicInfo,
      'dogHealthInfo': dogHealthInfo,
      'dogRoutine': dogRoutine,
      'problemBehaviors': problemBehaviors,
      'trainingGoals': trainingGoals,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  // copyWith method to create a new instance with updated fields
  Dog copyWith({
    String? id,
    String? ownerId,
    Map<String, dynamic>? guardianInfo,
    Map<String, dynamic>? dogBasicInfo,
    Map<String, dynamic>? dogHealthInfo,
    Map<String, dynamic>? dogRoutine,
    Map<String, dynamic>? problemBehaviors,
    Map<String, dynamic>? trainingGoals,
  }) {
    return Dog(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      guardianInfo: guardianInfo ?? this.guardianInfo,
      dogBasicInfo: dogBasicInfo ?? this.dogBasicInfo,
      dogHealthInfo: dogHealthInfo ?? this.dogHealthInfo,
      dogRoutine: dogRoutine ?? this.dogRoutine,
      problemBehaviors: problemBehaviors ?? this.problemBehaviors,
      trainingGoals: trainingGoals ?? this.trainingGoals,
    );
  }
}
