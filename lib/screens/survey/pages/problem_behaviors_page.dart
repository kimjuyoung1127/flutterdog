import 'package:flutter/material.dart';
import 'package:myapp/providers/survey_provider.dart';
import 'package:provider/provider.dart';

class ProblemBehaviorsPage extends StatefulWidget {
  const ProblemBehaviorsPage({super.key});

  @override
  State<ProblemBehaviorsPage> createState() => _ProblemBehaviorsPageState();
}

class _ProblemBehaviorsPageState extends State<ProblemBehaviorsPage> {
  final Map<String, bool> _mainProblems = {
    'Separation Anxiety': false,
    'Barking': false,
    'Aggression': false,
    'Potty Accidents': false,
  };
  final Map<String, bool> _separationAnxietySymptoms = {
    'Howling/Barking': false,
    'Destructive Behavior': false,
    'Potty Accidents': false,
    'Scratching Doors': false,
    'Pacing/Restlessness': false,
  };
  final Map<String, bool> _barkingSituations = {
    'Doorbell': false,
    'Seeing People/Dogs Outside': false,
    'Specific Noises': false,
    'For Attention': false,
    'During Play': false,
  };
  final Map<String, bool> _aggressionTargets = {
    'Strangers': false,
    'Other Dogs': false,
    'Family Members': false,
    'Children': false,
  };
  final Map<String, bool> _pottyAccidentSituations = {
    'When left alone': false,
    'When excited': false,
    'Waking up': false,
    'On specific surfaces (rugs, beds)': false,
  };

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final surveyProvider = Provider.of<SurveyProvider>(
        context,
        listen: false,
      );
      final initialData = surveyProvider.getProblemBehaviors();

      if (initialData != null) {
        setState(() {
          _initializeProblem(
            initialData,
            'separation_anxiety',
            'Separation Anxiety',
            _separationAnxietySymptoms,
            'symptoms',
          );
          _initializeProblem(
            initialData,
            'barking',
            'Barking',
            _barkingSituations,
            'situations',
          );
          _initializeProblem(
            initialData,
            'aggression',
            'Aggression',
            _aggressionTargets,
            'targets',
          );
          _initializeProblem(
            initialData,
            'potty_accidents',
            'Potty Accidents',
            _pottyAccidentSituations,
            'situations',
          );
        });
      }
      _isInitialized = true;
    }
  }

  void _initializeProblem(
    Map<String, dynamic> data,
    String dataKey,
    String mainProblemKey,
    Map<String, bool> symptomMap,
    String symptomKey,
  ) {
    if (data[dataKey] != null && data[dataKey]['active'] == true) {
      _mainProblems[mainProblemKey] = true;
      List<String> symptoms = List<String>.from(
        data[dataKey][symptomKey] ?? [],
      );
      for (var symptom in symptoms) {
        if (symptomMap.containsKey(symptom)) {
          symptomMap[symptom] = true;
        }
      }
    }
  }

  void _updateProvider() {
    final provider = Provider.of<SurveyProvider>(context, listen: false);
    provider.updateProblemBehaviors({
      'separation_anxiety': {
        'active': _mainProblems['Separation Anxiety'],
        'symptoms': _separationAnxietySymptoms.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList(),
      },
      'barking': {
        'active': _mainProblems['Barking'],
        'situations': _barkingSituations.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList(),
      },
      'aggression': {
        'active': _mainProblems['Aggression'],
        'targets': _aggressionTargets.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList(),
      },
      'potty_accidents': {
        'active': _mainProblems['Potty Accidents'],
        'situations': _pottyAccidentSituations.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList(),
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProblemSection(
          title: 'Separation Anxiety',
          symptoms: _separationAnxietySymptoms,
        ),
        _buildProblemSection(title: 'Barking', symptoms: _barkingSituations),
        _buildProblemSection(title: 'Aggression', symptoms: _aggressionTargets),
        _buildProblemSection(
          title: 'Potty Accidents',
          symptoms: _pottyAccidentSituations,
        ),
      ],
    );
  }

  Widget _buildProblemSection({
    required String title,
    required Map<String, bool> symptoms,
  }) {
    return ExpansionTile(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      leading: Checkbox(
        value: _mainProblems[title],
        onChanged: (bool? value) {
          setState(() {
            _mainProblems[title] = value!;
            if (!value) {
              symptoms.updateAll((key, _) => false);
            }
          });
          _updateProvider();
        },
      ),
      children: symptoms.keys.map((String key) {
        return CheckboxListTile(
          title: Text(key),
          value: symptoms[key],
          onChanged: (bool? value) {
            setState(() {
              symptoms[key] = value!;
              if (value) {
                _mainProblems[title] = true;
              }
            });
            _updateProvider();
          },
        );
      }).toList(),
    );
  }
}
