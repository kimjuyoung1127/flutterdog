import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/dog_model.dart';

class DogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Dog>> getDogs() {
    final User? user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dogs')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Dog.fromFirestore(doc)).toList();
    });
  }

  Future<void> addDog(Dog dog) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("Authentication Error: User not logged in.");
    }
    
    final dogWithOwner = dog.copyWith(ownerId: user.uid);

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dogs')
        .add(dogWithOwner.toFirestore());
  }

  Future<void> updateDog(Dog dog) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("Authentication Error: User not logged in.");
    }
    if (dog.id == null) {
      throw Exception("Data Error: Dog ID cannot be null for an update.");
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dogs')
        .doc(dog.id)
        .update(dog.toFirestore());
  }

  Future<void> deleteDog(String dogId) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("Authentication Error: User not logged in.");
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dogs')
        .doc(dogId)
        .delete();
  }
}
