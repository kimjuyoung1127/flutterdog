import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String role;
  final String? assignedTrainerId;
  final List<String>? assignedClientIds;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    required this.role,
    this.assignedTrainerId,
    this.assignedClientIds,
  });

  // Factory constructor to create a UserModel from a Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserModel(
      uid: snapshot.id,
      email: data?['email'] as String?,
      displayName: data?['displayName'] as String?,
      role: data?['role'] as String? ?? 'owner', // Default role to 'owner'
      assignedTrainerId: data?['assignedTrainerId'] as String?,
      assignedClientIds: data?['assignedClientIds'] is Iterable
          ? List<String>.from(data?['assignedClientIds'])
          : null,
    );
  }

  // Method to convert a UserModel instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role,
      'assignedTrainerId': assignedTrainerId,
      'assignedClientIds': assignedClientIds,
    };
  }
}
