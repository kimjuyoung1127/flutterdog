import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/data/skill_tree_database.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/training_result_model.dart';
import 'package:flutter/foundation.dart';

class DogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DocumentReference<Map<String, dynamic>> _getDogDocument(String dogId) {
    final User? user = _auth.currentUser;
    if (user == null) throw Exception("Authentication Error: User not logged in.");
    return _firestore.collection('users').doc(user.uid).collection('dogs').doc(dogId);
  }

  Stream<List<Dog>> getDogs() {
    final User? user = _auth.currentUser;
    if (user == null) {
      debugPrint('[DogService.getDogs] No user logged in. Returning empty stream.');
      return Stream.value([]);
    }
    debugPrint('[DogService.getDogs] Start listening dogs for user=${user.uid}');
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dogs')
        .snapshots()
        .map((snapshot) {
          debugPrint('[DogService.getDogs] Snapshot docs=${snapshot.docs.length}, isFromCache=${snapshot.metadata.isFromCache}');
          final list = snapshot.docs.map((doc) {
            try {
              final dog = Dog.fromFirestore(doc);
              debugPrint('[DogService.getDogs] Loaded dog id=${dog.id} name=${dog.name}');
              return dog;
            } catch (e) {
              debugPrint('[DogService.getDogs] Parse error for doc ${doc.id}: $e');
              rethrow;
            }
          }).toList();
          return list;
        })
        .handleError((e) {
          debugPrint('[DogService.getDogs] Stream error: $e');
        });
  }
  
  Future<void> addDog(Dog dog) async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('[DogService.addDog] Failed: user not logged in');
      throw Exception('User not logged in');
    }
    final data = dog.toFirestore();
    debugPrint('[DogService.addDog] Creating dog for user=${user.uid} name=${dog.dogBasicInfo['name']}');
    final col = _firestore.collection('users').doc(user.uid).collection('dogs');
    final ref = await col.add(data);
    debugPrint('[DogService.addDog] Created with id=${ref.id}');
  }

  Future<void> updateDog(Dog dog) async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('[DogService.updateDog] Failed: user not logged in');
      throw Exception('User not logged in');
    }
    if (dog.id == null) {
      debugPrint('[DogService.updateDog] Failed: dog.id is null');
      throw Exception('Dog ID is required for update');
    }
    debugPrint('[DogService.updateDog] Updating dog id=${dog.id} for user=${user.uid}');
    await _getDogDocument(dog.id!).set(dog.toFirestore(), SetOptions(merge: true));
    debugPrint('[DogService.updateDog] Update success for id=${dog.id}');
  }

  Future<void> chooseDogClass(String dogId, String className) async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('[DogService.chooseDogClass] Failed: user not logged in');
      throw Exception('User not logged in');
    }
    debugPrint('[DogService.chooseDogClass] dogId=$dogId class=$className');
    await _getDogDocument(dogId).set({'dogClass': className}, SetOptions(merge: true));
    debugPrint('[DogService.chooseDogClass] Success dogId=$dogId');
  }

  Future<void> learnSkill(String dogId, String skillId) async {
    // 최소 구현: 해당 스킬 카운트를 1 증가
    debugPrint('[DogService.learnSkill] dogId=$dogId skillId=$skillId');
    await _getDogDocument(dogId).set(
      {
        'skills': {skillId: FieldValue.increment(1)}
      },
      SetOptions(merge: true),
    );
    debugPrint('[DogService.learnSkill] increment done dogId=$dogId skillId=$skillId');
  }

  Future<void> completeTrainingSession(String dogId, TrainingResult result, String logEntry) async {
    // 아직 LogSessionScreen에서 실제 호출 연결 전이므로, 최소 로깅만 유지
    debugPrint('[DogService.completeTrainingSession] dogId=$dogId success=${result.isSuccess} tp=${result.quest.rewardTp} materials=${result.quest.rewardMaterials}');
    // 구현 예정
  }
  // ... (and all other necessary methods)
}
