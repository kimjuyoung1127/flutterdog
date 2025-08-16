import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/providers/survey_provider.dart';
import 'package:provider/provider.dart';

class GuardianInfoPage extends StatefulWidget {
  const GuardianInfoPage({super.key});

  @override
  State<GuardianInfoPage> createState() => _GuardianInfoPageState();
}

class _GuardianInfoPageState extends State<GuardianInfoPage> {
  String? _ageGroup;
  String? _occupation;
  final _householdSizeController = TextEditingController();
  final _familyInteractionController = TextEditingController();
  final _pastExperienceController = TextEditingController();
  
  final Map<String, bool> _familyMembers = {
    'Spouse': false, 'Preschooler': false, 'School-aged Child': false,
    'Parent(s)': false, 'Sibling(s)': false, 'Roommate(s)': false,
  };
  bool _isFirstDog = true;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
      final initialData = surveyProvider.getGuardianInfo();

      if (initialData != null) {
        _ageGroup = initialData['age_group'];
        _occupation = initialData['occupation'];
        _householdSizeController.text = initialData['household_size']?.toString() ?? '';
        _familyInteractionController.text = initialData['family_interaction'] ?? '';
        _pastExperienceController.text = initialData['past_experience'] ?? '';
        _isFirstDog = initialData['is_first_dog'] ?? true;
        
        List<String> family = List<String>.from(initialData['family_members'] ?? []);
        for (var member in family) {
          if (_familyMembers.containsKey(member)) {
            _familyMembers[member] = true;
          }
        }
      }
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _householdSizeController.addListener(_updateProvider);
    _familyInteractionController.addListener(_updateProvider);
    _pastExperienceController.addListener(_updateProvider);
  }

  @override
  void dispose() {
    _householdSizeController.dispose();
    _familyInteractionController.dispose();
    _pastExperienceController.dispose();
    super.dispose();
  }

  void _updateProvider() {
    final provider = Provider.of<SurveyProvider>(context, listen: false);
    provider.updateGuardianInfo({
      'age_group': _ageGroup,
      'occupation': _occupation,
      'family_members': _familyMembers.entries.where((e) => e.value).map((e) => e.key).toList(),
      'household_size': int.tryParse(_householdSizeController.text),
      'family_interaction': _familyInteractionController.text, // This should be updated based on the new UI
      'is_first_dog': _isFirstDog,
      'past_experience': _pastExperienceController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: const Text('Basic Information'),
          initiallyExpanded: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _ageGroup,
                    hint: const Text('Select your age group'),
                    decoration: const InputDecoration(labelText: 'Age Group', border: OutlineInputBorder()),
                    items: ['20s', '30s', '40s', '50s', '60+']
                        .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _ageGroup = value);
                      _updateProvider();
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _occupation,
                    hint: const Text('Select your occupation'),
                    decoration: const InputDecoration(labelText: 'Occupation', border: OutlineInputBorder()),
                    items: ['Office Worker', 'Field Worker', 'Freelancer', 'Student', 'Homemaker']
                        .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _occupation = value);
                      _updateProvider();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Family & Household'),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _householdSizeController,
                    decoration: const InputDecoration(labelText: 'Number of people in household', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),
                  const Text('Family Members', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8.0,
                    children: _familyMembers.keys.map((String key) {
                      return FilterChip(
                        label: Text(key),
                        selected: _familyMembers[key]!,
                        onSelected: (bool selected) {
                          setState(() => _familyMembers[key] = selected);
                          _updateProvider();
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // This text form field is what we should replace
                  TextFormField(
                    controller: _familyInteractionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'How does each family member interact with the dog?',
                      hintText: 'e.g., Husband takes evening walks...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Past Experience'),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Is this your first dog?'),
                    value: _isFirstDog,
                    onChanged: (bool value) {
                      setState(() => _isFirstDog = value);
                      _updateProvider();
                    },
                  ),
                  if (!_isFirstDog) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pastExperienceController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Past Dog Experience',
                        hintText: 'Breed, time together, etc.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
