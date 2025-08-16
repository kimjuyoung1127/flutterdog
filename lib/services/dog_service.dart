import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/data/skill_tree_database.dart';

class DogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DocumentReference<Map<String, dynamic>> _getDogDocument(String dogId) {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("Authentication Error: User not logged in.");
    }
    return _firestore.collection('users').doc(user.uid).collection('dogs').doc(dogId);
  }

  Stream<List<Dog>> getDogs() {
    final User? user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return _firestore.collection('users').doc(user.uid).collection('dogs').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Dog.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addDog(Dog dog) async {
    final User? user = _auth.currentUser;
    if (user == null) throw Exception("Authentication Error: User not logged in.");
    final dogWithOwner = dog.copyWith(ownerId: user.uid);
    await _firestore.collection('users').doc(user.uid).collection('dogs').add(dogWithOwner.toFirestore());
  }

  Future<void> updateDog(Dog dog) async {
    if (dog.id == null) throw Exception("Data Error: Dog ID cannot be null for an update.");
    await _getDogDocument(dog.id!).update(dog.toFirestore());
  }

  Future<void> deleteDog(String dogId) async {
    await _getDogDocument(dogId).delete();
  }
  
  Future<void> chooseDogClass(String dogId, String className) async {
    await _getDogDocument(dogId).update({'dogClass': className});
  }

  Future<void> learnSkill(String dogId, String skillId) async {
    final dogDocRef = _getDogDocument(dogId);
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(dogDocRef);
      if (!snapshot.exists) throw Exception("Dog not found!");

      final dog = Dog.fromFirestore(snapshot);
      final skill = SkillTreeDatabase.skills[skillId];
      if (skill == null) throw Exception("Skill not found!");

      final currentSkillLevel = dog.skills[skillId] ?? 0;
      if (currentSkillLevel >= skill.maxLevel) throw Exception("Skill is already at max level!");
      if (dog.trainingPoints < skill.requiredTp) throw Exception("Not enough Training Points!");
      
      for (var entry in skill.craftingMaterials.entries) {
        if ((dog.inventory[entry.key] ?? 0) < entry.value) {
          throw Exception("Not enough materials! Missing ${entry.key}.");
        }
      }

      final newInventory = Map<String, int>.from(dog.inventory);
      skill.craftingMaterials.forEach((materialId, requiredAmount) {
        newInventory.update(materialId, (value) => value - requiredAmount);
      });

      final newSkills = Map<String, int>.from(dog.skills);
      newSkills[skillId] = currentSkillLevel + 1;
      
      final rewardItemId = skill.milestoneRewards[newSkills[skillId]];
      if (rewardItemId != null) {
        newInventory.update(rewardItemId, (value) => value + 1, ifAbsent: () => 1);
      }

      transaction.update(dogDocRef, {
        'trainingPoints': dog.trainingPoints - skill.requiredTp,
        'inventory': newInventory,
        'skills': newSkills,
      });
    });
  }

  Future<void> addItemsToInventory(String dogId, Map<String, int> itemsToAdd) async {
    // ... implementation ...
  }
  
  Future<void> equipItem(String dogId, String itemId, String slot) async {
    // ... implementation ...
  }

  Future<void> unequipItem(String dogId, String slot) async {
    // ... implementation ...
  }
}
