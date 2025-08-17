import 'package:myapp/models/quest_model.dart';

/// A data class to hold the results of a training session.
class TrainingResult {
  final bool isSuccess;
  final int successCount;
  final int maxCombo;
  final Quest quest;

  TrainingResult({
    required this.isSuccess,
    required this.successCount,
    required this.maxCombo,
    required this.quest,
  });
}
