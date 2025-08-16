import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/user_model.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // New method for anonymous sign-in for quick development
  Future<User?> signInAnonymously() async {
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      final User? user = userCredential.user;
      if (user != null) {
        // We can still create a document in Firestore for the anonymous user
        // to keep data structure consistent.
        await _createUserInFirestore(user, isAnonymous: true);
      }
      notifyListeners();
      return user;
    } catch (e) {
      debugPrint('Error during anonymous sign-in: $e');
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      if (kIsWeb) {
        await _auth.signInWithRedirect(googleProvider);
        return null;
      } else {
        final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
        final User? user = userCredential.user;
        if (user != null) {
          await _createUserInFirestore(user);
        }
        notifyListeners();
        return user;
      }
    } catch (e) {
      debugPrint('Error during Google sign-in: $e');
      rethrow;
    }
  }

  Future<void> _createUserInFirestore(User user, {bool isAnonymous = false}) async {
    final userDocRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await userDocRef.get();

    if (!userDoc.exists) {
      final newUser = UserModel(
        uid: user.uid,
        // For anonymous users, email and displayName will be null.
        email: isAnonymous ? 'anonymous@petpartner.com' : user.email,
        displayName: isAnonymous ? 'Anonymous User' : user.displayName,
        role: 'owner',
        assignedTrainerId: null,
        assignedClientIds: [],
      );
      await userDocRef.set(newUser.toFirestore());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
