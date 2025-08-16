import 'package:flutter/material.dart';
import 'package:myapp/providers/survey_provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class DogHealthPage extends StatefulWidget {
  const DogHealthPage({super.key});

  @override
  State<DogHealthPage> createState() => _DogHealthPageState();
}

class _DogHealthPageState extends State<DogHealthPage> {
  // State for form fields
  int _weightKg = 10;
  int _weightG = 0;
  String? _dietType;
  final _historyController = TextEditingController();
  final Map<String, bool> _commonIssues = {
    'Patellar Luxation': false, 'Skin Allergies': false, 
    'Heart Disease': false, 'Dental Issues': false,
  };
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
      final initialData = surveyProvider.getDogHealthInfo();

      if (initialData != null) {
        setState(() {
          double weight = initialData['weight_kg'] ?? 10.0;
          _weightKg = weight.floor();
          _weightG = ((weight - _weightKg) * 10).round();
          _dietType = initialData['diet_type'];
          _historyController.text = initialData['medical_history_details'] ?? '';

          List<String> issues = List<String>.from(initialData['common_medical_issues'] ?? []);
          for (var issue in issues) {
            if (_commonIssues.containsKey(issue)) {
              _commonIssues[issue] = true;
            }
          }
        });
      }
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _historyController.addListener(_updateProvider);
  }

  @override
  void dispose() {
    _historyController.dispose();
    super.dispose();
  }

  void _updateProvider() {
    final provider = Provider.of<SurveyProvider>(context, listen: false);
    final weight = _weightKg + (_weightG / 10.0);
    provider.updateDogHealthInfo({
      'weight_kg': weight,
      'diet_type': _dietType,
      'common_medical_issues': _commonIssues.entries.where((e) => e.value).map((e) => e.key).toList(),
      'medical_history_details': _historyController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Weight', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberPicker(
                      minValue: 0,
                      maxValue: 100,
                      value: _weightKg,
                      onChanged: (value) {
                        setState(() => _weightKg = value);
                        _updateProvider();
                      },
                    ),
                    const Text('.'),
                    NumberPicker(
                      minValue: 0,
                      maxValue: 9,
                      value: _weightG,
                      onChanged: (value) {
                        setState(() => _weightG = value);
                        _updateProvider();
                      },
                    ),
                    const Text('kg'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        DropdownButtonFormField<String>(
          value: _dietType,
          hint: const Text('Select food type'),
          decoration: const InputDecoration(labelText: 'Type of Food', border: OutlineInputBorder()),
          items: ['Dry Food (Kibble)', 'Wet Food', 'Homemade (Cooked)', 'Raw (BARF)', 'Other']
              .map((label) => DropdownMenuItem(value: label, child: Text(label)))
              .toList(),
          onChanged: (value) {
            setState(() => _dietType = value);
            _updateProvider();
          },
        ),
        const SizedBox(height: 24),

        ExpansionTile(
          title: const Text('Medical History'),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Check any known issues:'),
            ),
            ..._commonIssues.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: _commonIssues[key],
                onChanged: (bool? value) {
                  setState(() {
                    _commonIssues[key] = value!;
                  });
                  _updateProvider();
                },
              );
            }),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _historyController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Other Details',
                  hintText: 'Any other past illnesses, surgeries, or allergies?',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
