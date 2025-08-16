import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/dog_breeds.dart';
import 'package:myapp/providers/survey_provider.dart';
import 'package:provider/provider.dart';

class DogBasicInfoPage extends StatefulWidget {
  const DogBasicInfoPage({super.key});

  @override
  State<DogBasicInfoPage> createState() => _DogBasicInfoPageState();
}

class _DogBasicInfoPageState extends State<DogBasicInfoPage> {
  final _breedController = TextEditingController();
  final _nameController = TextEditingController();
  DateTime? _birthDate;
  bool _isNeutered = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
      final initialData = surveyProvider.getDogBasicInfo();

      if (initialData != null) {
        setState(() {
          _breedController.text = initialData['breed'] ?? '';
          _nameController.text = initialData['name'] ?? '';
          _birthDate = initialData['birth_date'];
          _isNeutered = initialData['is_neutered'] ?? false;
        });
      }
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _breedController.addListener(_updateProvider);
    _nameController.addListener(_updateProvider);
  }

  @override
  void dispose() {
    _breedController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _updateProvider() {
    final provider = Provider.of<SurveyProvider>(context, listen: false);
    provider.updateDogBasicInfo({
      'breed': _breedController.text,
      'name': _nameController.text,
      'birth_date': _birthDate,
      'is_neutered': _isNeutered,
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
      _updateProvider();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') return const Iterable<String>.empty();
            return kDogBreeds.where((o) => o.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (String selection) {
            _breedController.text = selection;
          },
          fieldViewBuilder: (context, fieldController, focusNode, onFieldSubmitted) {
            // Sync our controller with the field's controller
            fieldController.text = _breedController.text;
            return TextFormField(
              controller: fieldController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Breed',
                hintText: 'Start typing your dog\'s breed...',
                border: OutlineInputBorder(),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 24),
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            hintText: _birthDate == null ? 'Tap to select a date' : DateFormat.yMMMd().format(_birthDate!),
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          onTap: () => _selectDate(context),
        ),
        const SizedBox(height: 24),
        SwitchListTile(
          title: const Text('Is your dog neutered/spayed?'),
          value: _isNeutered,
          onChanged: (bool value) {
            setState(() {
              _isNeutered = value;
            });
            _updateProvider();
          },
        ),
      ],
    );
  }
}
