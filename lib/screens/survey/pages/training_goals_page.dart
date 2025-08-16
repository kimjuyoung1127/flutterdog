import 'package:flutter/material.dart';
import 'package:myapp/providers/survey_provider.dart';
import 'package:provider/provider.dart';

class TrainingGoalsPage extends StatefulWidget {
  const TrainingGoalsPage({super.key});

  @override
  State<TrainingGoalsPage> createState() => _TrainingGoalsPageState();
}

class _TrainingGoalsPageState extends State<TrainingGoalsPage> {
  final _priority1Controller = TextEditingController();
  final _priority2Controller = TextEditingController();
  final _relationshipGoalController = TextEditingController();
  double _investableTime = 30.0;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
      final initialData = surveyProvider.getTrainingGoals();

      if (initialData != null) {
        setState(() {
          _priority1Controller.text = initialData['priority_1'] ?? '';
          _priority2Controller.text = initialData['priority_2'] ?? '';
          _relationshipGoalController.text = initialData['relationship_goal'] ?? '';
          _investableTime = (initialData['investable_time_min'] ?? 30).toDouble();
        });
      }
      _isInitialized = true;
    }
  }
  
  @override
  void initState() {
    super.initState();
    _priority1Controller.addListener(_updateProvider);
    _priority2Controller.addListener(_updateProvider);
    _relationshipGoalController.addListener(_updateProvider);
  }

  @override
  void dispose() {
    _priority1Controller.dispose();
    _priority2Controller.dispose();
    _relationshipGoalController.dispose();
    super.dispose();
  }

  void _updateProvider() {
    final provider = Provider.of<SurveyProvider>(context, listen: false);
    provider.updateTrainingGoals({
      'priority_1': _priority1Controller.text,
      'priority_2': _priority2Controller.text,
      'relationship_goal': _relationshipGoalController.text,
      'investable_time_min': _investableTime.round(),
    });
  }

  @override
  Widget build(BuildContext context) {
    // **FIX**: Changed ListView to Column to resolve the unbounded height/freeze error.
    return Column(
      children: [
        Text(
          'What is your top training priority?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        TextFormField(
          controller: _priority1Controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Reduce separation anxiety',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'What is your second training priority?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        TextFormField(
          controller: _priority2Controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Leash pulling',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'How much time can you invest in training daily?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Slider(
          value: _investableTime,
          min: 15,
          max: 120,
          divisions: 7,
          label: '${_investableTime.round()} minutes',
          onChanged: (double value) {
            setState(() {
              _investableTime = value;
            });
            _updateProvider();
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Ultimately, what kind of relationship do you want with your dog?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        TextFormField(
          controller: _relationshipGoalController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Describe your ideal bond...',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
