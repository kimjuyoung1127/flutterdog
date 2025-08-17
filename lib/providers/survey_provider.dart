import 'package:flutter/material.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/services/dog_service.dart';
import 'package:flutter/foundation.dart';

class SurveyProvider with ChangeNotifier {
  final DogService _dogService;

  SurveyProvider(this._dogService);
  
  Map<String, dynamic>? _guardianInfo;
  Map<String, dynamic>? _dogBasicInfo;
  Map<String, dynamic>? _dogHealthInfo;
  Map<String, dynamic>? _dogRoutine;
  Map<String, dynamic>? _problemBehaviors;
  Map<String, dynamic>? _trainingGoals;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? getGuardianInfo() => _guardianInfo;
  Map<String, dynamic>? getDogBasicInfo() => _dogBasicInfo;
  Map<String, dynamic>? getDogHealthInfo() => _dogHealthInfo;
  Map<String, dynamic>? getDogRoutine() => _dogRoutine;
  Map<String, dynamic>? getProblemBehaviors() => _problemBehaviors;
  Map<String, dynamic>? getTrainingGoals() => _trainingGoals;

  void loadInitialData(Dog? dog) {
    if (dog != null) {
      _guardianInfo = dog.guardianInfo;
      _dogBasicInfo = dog.dogBasicInfo;
      _dogHealthInfo = dog.dogHealthInfo;
      _dogRoutine = dog.dogRoutine;
      _problemBehaviors = dog.problemBehaviors;
      _trainingGoals = dog.trainingGoals;
    }
  }

  void updateGuardianInfo(Map<String, dynamic> data) => _guardianInfo = data;
  void updateDogBasicInfo(Map<String, dynamic> data) => _dogBasicInfo = data;
  void updateDogHealthInfo(Map<String, dynamic> data) => _dogHealthInfo = data;
  void updateDogRoutine(Map<String, dynamic> data) => _dogRoutine = data;
  void updateProblemBehaviors(Map<String, dynamic> data) => _problemBehaviors = data;
  void updateTrainingGoals(Map<String, dynamic> data) => _trainingGoals = data;

  Future<bool> submitSurvey({
    required String userId, 
    String? dogId,
    required bool isEditMode,
  }) async {
    // Only basic info is required to create/update a profile.
    if (_dogBasicInfo == null || _dogBasicInfo!['name'] == null || _dogBasicInfo!['breed'] == null) {
      _errorMessage = "Please at least provide the dog's name and breed.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final dog = Dog(
      id: dogId,
      ownerId: userId,
      // Use existing data or default to an empty map if null.
      guardianInfo: _guardianInfo ?? {},
      dogBasicInfo: _dogBasicInfo!,
      dogHealthInfo: _dogHealthInfo ?? {},
      dogRoutine: _dogRoutine ?? {},
      problemBehaviors: _problemBehaviors ?? {},
      trainingGoals: _trainingGoals ?? {},
    );

    debugPrint('[SurveyProvider.submitSurvey] mode=${isEditMode ? 'edit' : 'create'} '
        'userId=$userId dogId=${dogId ?? '(new)'} name=${dog.dogBasicInfo['name']} breed=${dog.dogBasicInfo['breed']}');

    try {
      if (isEditMode) {
        await _dogService.updateDog(dog);
        debugPrint('[SurveyProvider.submitSurvey] updateDog OK id=${dog.id}');
      } else {
        await _dogService.addDog(dog);
        debugPrint('[SurveyProvider.submitSurvey] addDog OK');
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('[SurveyProvider.submitSurvey] ERROR: $_errorMessage');
      return false;
    }
  }
}
