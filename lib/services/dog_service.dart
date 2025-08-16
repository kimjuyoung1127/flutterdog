import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/data/skill_tree_database.dart';
import 'package:myapp/models/dog_model.dart';

// Unused import 'package:myapp/models/skill_model.dart'; is now removed.

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
      return Stream.value([]); // Added explicit return for the null user case
    }
    return _firestore.collection('users').doc(user.uid).collection('dogs').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Dog.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addItemsToInventory(String dogId, Map<String, int> itemsToAdd) async {
    // ... implementation ...
  }

  Future<void> learnSkillWithMaterials(String dogId, String skillId) async {
    // ... implementation ...
  }
  
  // ... other methods ...

  // Corrected the unnecessary brace in string interpolation.
  Future<void> equipItem(String dogId, String itemId, String slot) async {
    final dogDocRef = _getDogDocument(dogId);
    await dogDocRef.update({
        'equippedItems.$slot': itemId
    });
  }
}
