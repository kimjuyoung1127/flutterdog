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
  final String? dogClass;
  final int trainingPoints;
  final Map<String, int> skills;
  // inventory is now a map to store the quantity of each item/material.
  final Map<String, int> inventory; 
  final Map<String, String> equippedItems;
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
    this.dogClass,
    this.trainingPoints = 0,
    this.skills = const {},
    this.inventory = const {}, // Default to an empty map
    this.equippedItems = const {},
    this.trainingEnergy = const {'currentValue': 100, 'lastUpdatedAt': null},
  });

  String get name => dogBasicInfo['name'] as String? ?? 'Unnamed';
  String get breed => dogBasicInfo['breed'] as String? ?? 'Unknown Breed';

  factory Dog.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    // Safely parse the inventory from Firestore, defaulting to an empty map.
    final inventoryData = data['inventory'] as Map?;
    final inventory = inventoryData != null ? Map<String, int>.from(inventoryData) : <String, int>{};

    return Dog(
      id: snapshot.id,
      ownerId: data['ownerId'] as String,
      guardianInfo: data['guardianInfo'] as Map<String, dynamic>? ?? {},
      dogBasicInfo: data['dogBasicInfo'] as Map<String, dynamic>? ?? {},
      dogHealthInfo: data['dogHealthInfo'] as Map<String, dynamic>? ?? {},
      dogRoutine: data['dogRoutine'] as Map<String, dynamic>? ?? {},
      problemBehaviors: data['problemBehaviors'] as Map<String, dynamic>? ?? {},
      trainingGoals: data['trainingGoals'] as Map<String, dynamic>? ?? {},
      dogClass: data['dogClass'] as String?,
      trainingPoints: data['trainingPoints'] as int? ?? 0,
      skills: Map<String, int>.from(data['skills'] as Map? ?? {}),
      inventory: inventory,
      equippedItems: Map<String, String>.from(data['equippedItems'] as Map? ?? {}),
      trainingEnergy: data['trainingEnergy'] as Map<String, dynamic>? ?? {'currentValue': 100, 'lastUpdatedAt': FieldValue.serverTimestamp()},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'guardianInfo': guardianInfo,
      'dogBasicInfo': dogBasicInfo,
      'dogHealthInfo': dogHealthInfo,
      'dogRoutine': dogRoutine,
      'problemBehaviors': problemBehaviors,
      'trainingGoals': trainingGoals,
      'dogClass': dogClass,
      'trainingPoints': trainingPoints,
      'skills': skills,
      'inventory': inventory,
      'equippedItems': equippedItems,
      'trainingEnergy': trainingEnergy,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

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
    Map<String, int>? inventory, // Updated type
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
