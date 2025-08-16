import 'package:cloud_firestore/cloud_firestore.dart';

class Dog {
  final String? id;
  final String ownerId;
  
  // --- Original Survey Data ---
  final Map<String, dynamic> guardianInfo;
  final Map<String, dynamic> dogBasicInfo;
  final Map<String, dynamic> dogHealthInfo;
  final Map<String, dynamic> dogRoutine;
  final Map<String, dynamic> problemBehaviors;
  final Map<String, dynamic> trainingGoals;

  // --- v5.0 Class Growth System ---
  final String? dogClass; // e.g., 'guardian', 'sage', 'ranger', 'warrior'
  final int trainingPoints;
  // Map of Skill IDs to their current level, e.g., {'house_training': 2, 'leash_manners': 1}
  final Map<String, int> skills;
  // List of Item IDs in the inventory
  final List<String> inventory;
  // Map of ItemSlots to Item IDs, e.g., {'head': 'item_smart_hat', 'body': 'item_sturdy_harness'}
  final Map<String, String> equippedItems;
  // Map to manage the training energy system
  final Map<String, dynamic> trainingEnergy;


  Dog({
    this.id,
    required this.ownerId,
    this.guardianInfo = const {},
    this.dogBasicInfo = const {},
    this.dogHealthInfo = const {},
    this.dogRoutine = const {},
    this.problemBehaviors = const {},
    this.trainingGoals = const {},
    // Initialize new fields with default values
    this.dogClass,
    this.trainingPoints = 0,
    this.skills = const {},
    this.inventory = const [],
    this.equippedItems = const {},
    this.trainingEnergy = const {'currentValue': 100, 'lastUpdatedAt': null},
  });

  // Helper getters
  String get name => dogBasicInfo['name'] as String? ?? 'Unnamed';
  String get breed => dogBasicInfo['breed'] as String? ?? 'Unknown Breed';

  // Factory from Firestore
  factory Dog.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Dog(
      id: snapshot.id,
      ownerId: data['ownerId'] as String,
      // --- Original Fields ---
      guardianInfo: data['guardianInfo'] as Map<String, dynamic>? ?? {},
      dogBasicInfo: data['dogBasicInfo'] as Map<String, dynamic>? ?? {},
      dogHealthInfo: data['dogHealthInfo'] as Map<String, dynamic>? ?? {},
      dogRoutine: data['dogRoutine'] as Map<String, dynamic>? ?? {},
      problemBehaviors: data['problemBehaviors'] as Map<String, dynamic>? ?? {},
      trainingGoals: data['trainingGoals'] as Map<String, dynamic>? ?? {},
      // --- New v5.0 Fields (with backward compatibility) ---
      dogClass: data['dogClass'] as String?,
      trainingPoints: data['trainingPoints'] as int? ?? 0,
      skills: Map<String, int>.from(data['skills'] as Map? ?? {}),
      inventory: List<String>.from(data['inventory'] as List? ?? []),
      equippedItems: Map<String, String>.from(data['equippedItems'] as Map? ?? {}),
      trainingEnergy: data['trainingEnergy'] as Map<String, dynamic>? ?? {'currentValue': 100, 'lastUpdatedAt': FieldValue.serverTimestamp()},
    );
  }

  // Method to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      // --- Original Fields ---
      'guardianInfo': guardianInfo,
      'dogBasicInfo': dogBasicInfo,
      'dogHealthInfo': dogHealthInfo,
      'dogRoutine': dogRoutine,
      'problemBehaviors': problemBehaviors,
      'trainingGoals': trainingGoals,
      // --- New v5.0 Fields ---
      'dogClass': dogClass,
      'trainingPoints': trainingPoints,
      'skills': skills,
      'inventory': inventory,
      'equippedItems': equippedItems,
      'trainingEnergy': trainingEnergy,
      // --- Metadata ---
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  // copyWith method
  Dog copyWith({
    String? id,
    String? ownerId,
    Map<String, dynamic>? guardianInfo,
    Map<String, dynamic>? dogBasicInfo,
    Map<String, dynamic>? dogHealthInfo,
    Map<String, dynamic>? dogRoutine,
    Map<String, dynamic>? problemBehaviors,
    Map<String, dynamic>? trainingGoals,
    String? dogClass,
    int? trainingPoints,
    Map<String, int>? skills,
    List<String>? inventory,
    Map<String, String>? equippedItems,
    Map<String, dynamic>? trainingEnergy,
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
      dogClass: dogClass ?? this.dogClass,
      trainingPoints: trainingPoints ?? this.trainingPoints,
      skills: skills ?? this.skills,
      inventory: inventory ?? this.inventory,
      equippedItems: equippedItems ?? this.equippedItems,
      trainingEnergy: trainingEnergy ?? this.trainingEnergy,
    );
  }
}
