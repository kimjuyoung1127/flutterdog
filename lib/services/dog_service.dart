import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/data/skill_tree_database.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/training_result_model.dart';

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
    if (user == null) return Stream.value([]);
    return _firestore.collection('users').doc(user.uid).collection('dogs').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Dog.fromFirestore(doc)).toList(),
        );
  }
  
  Future<void> addDog(Dog dog) async { /* ... implementation ... */ }
  Future<void> updateDog(Dog dog) async { /* ... implementation ... */ }
  Future<void> chooseDogClass(String dogId, String className) async { /* ... implementation ... */ }
  Future<void> learnSkill(String dogId, String skillId) async { /* ... implementation ... */ }
  Future<void> completeTrainingSession(String dogId, TrainingResult result, String logEntry) async { /* ... implementation ... */ }
  // ... (and all other necessary methods)
}
