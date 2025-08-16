import 'package:flutter/material.dart';
import 'package:myapp/providers/survey_provider.dart';
import 'package:provider/provider.dart';

class DogRoutinePage extends StatefulWidget {
  const DogRoutinePage({super.key});

  @override
  State<DogRoutinePage> createState() => _DogRoutinePageState();
}

class _DogRoutinePageState extends State<DogRoutinePage> {
  // State for form fields
  double _aloneHours = 4.0;
  int? _walkFrequency;
  String? _housingType;
  bool _hasPersonalSpace = false;
  double _comfortLevel = 3.0;
  
  final Map<String, bool> _walkSlots = {'Morning': false, 'Afternoon': false, 'Evening': false, 'Night': false};
  final Map<String, bool> _dailyActivities = {
    'Sleeping': false, 'Toy Play': false, 'Window Gazing': false, 
    'Following Guardian': false, 'Eating/Drinking': false,
  };
  final Map<String, bool> _favoriteToys = {'Balls': false, 'Dolls': false, 'Nosework': false, 'Tug': false};
  
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
      final initialData = surveyProvider.getDogRoutine();

      if (initialData != null) {
        setState(() {
          _aloneHours = (initialData['alone_hours_per_day'] ?? 4).toDouble();
          _walkFrequency = initialData['walk_frequency_per_day'];
          _housingType = initialData['housing_type'];
          _hasPersonalSpace = initialData['has_personal_space'] ?? false;
          _comfortLevel = (initialData['comfort_level_in_space'] ?? 3).toDouble();

          _initializeMap(_walkSlots, initialData['walk_time_slots']);
          _initializeMap(_dailyActivities, initialData['daily_activities']);
          _initializeMap(_favoriteToys, initialData['favorite_toys']);
        });
      }
      _isInitialized = true;
    }
  }

  void _initializeMap(Map<String, bool> map, List<dynamic>? keys) {
    if (keys != null) {
      for (var key in keys) {
        if (map.containsKey(key)) {
          map[key] = true;
        }
      }
    }
  }

  void _updateProvider() {
    final provider = Provider.of<SurveyProvider>(context, listen: false);
    provider.updateDogRoutine({
      'alone_hours_per_day': _aloneHours.round(),
      'walk_frequency_per_day': _walkFrequency,
      'walk_time_slots': _walkSlots.entries.where((e) => e.value).map((e) => e.key).toList(),
      'housing_type': _housingType,
      'has_personal_space': _hasPersonalSpace,
      'comfort_level_in_space': _comfortLevel.round(),
      'daily_activities': _dailyActivities.entries.where((e) => e.value).map((e) => e.key).toList(),
      'favorite_toys': _favoriteToys.entries.where((e) => e.value).map((e) => e.key).toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: const Text('Daily Routine'),
          initiallyExpanded: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How many hours is the dog alone per day?', style: Theme.of(context).textTheme.titleMedium),
                  Slider(
                    value: _aloneHours,
                    min: 0, max: 12, divisions: 12,
                    label: '${_aloneHours.round()} hours',
                    onChanged: (double value) {
                      setState(() => _aloneHours = value);
                      _updateProvider();
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('How many times do you walk your dog per day?', style: Theme.of(context).textTheme.titleMedium),
                  ...[1, 2, 3, 4].map((int value) {
                    return RadioListTile<int>(
                      title: Text('$value time(s)'),
                      value: value, groupValue: _walkFrequency,
                      onChanged: (int? newValue) {
                        setState(() => _walkFrequency = newValue);
                        _updateProvider();
                      },
                    );
                  }),
                ],
              ),
            )
          ],
        ),
        ExpansionTile(
          title: const Text('Home Environment'),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _housingType,
                    hint: const Text('Select housing type'),
                    decoration: const InputDecoration(labelText: 'Housing Type', border: OutlineInputBorder()),
                    items: ['Apartment', 'Villa', 'Single-family House', 'Officetel']
                        .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _housingType = value);
                      _updateProvider();
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Does your dog have their own space?'),
                    value: _hasPersonalSpace,
                    onChanged: (bool value) {
                      setState(() => _hasPersonalSpace = value);
                      _updateProvider();
                    },
                  ),
                  if (_hasPersonalSpace) ...[
                     Text('How comfortable are they in that space? (1=Not at all, 5=Very)', style: Theme.of(context).textTheme.bodyLarge),
                    Slider(
                      value: _comfortLevel,
                      min: 1, max: 5, divisions: 4,
                      label: _comfortLevel.round().toString(),
                      onChanged: (double value) {
                        setState(() => _comfortLevel = value);
                        _updateProvider();
                      },
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
        ExpansionTile(
          title: const Text('Activities & Play'),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('What does your dog mainly do during the day?', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8.0,
                    children: _dailyActivities.keys.map((String key) {
                      return FilterChip(
                        label: Text(key),
                        selected: _dailyActivities[key]!,
                        onSelected: (bool selected) {
                          setState(() => _dailyActivities[key] = selected);
                          _updateProvider();
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Favorite types of toys', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8.0,
                    children: _favoriteToys.keys.map((String key) {
                      return FilterChip(
                        label: Text(key),
                        selected: _favoriteToys[key]!,
                        onSelected: (bool selected) {
                          setState(() => _favoriteToys[key] = selected);
                          _updateProvider();
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
