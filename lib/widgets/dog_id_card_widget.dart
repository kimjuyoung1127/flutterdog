import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/dog_model.dart';

class DogIdCardWidget extends StatelessWidget {
  final Dog dog;
  final VoidCallback onEdit;

  const DogIdCardWidget({
    super.key,
    required this.dog,
    required this.onEdit,
  });

  Map<String, dynamic> _calculateProfileStats() {
    int totalFields = 10;
    int completedFields = 0;

    if (dog.guardianInfo.isNotEmpty) completedFields++;
    if (dog.dogBasicInfo['name'] != null) completedFields++;
    if (dog.dogBasicInfo['breed'] != null) completedFields++;
    if (dog.dogHealthInfo.isNotEmpty) completedFields++;
    if (dog.dogRoutine.isNotEmpty) completedFields++;
    
    double completion = completedFields / totalFields;
    int level = (completion * 10).clamp(1, 10).toInt();

    return {'completion': completion, 'level': level};
  }

  List<String> _getNotableTraits() {
    final traits = <String>[];
    if (dog.trainingGoals['goals'] != null && (dog.trainingGoals['goals'] as List).isNotEmpty) {
      traits.add('Ambitious');
    }
    if (dog.problemBehaviors['barking'] == true) {
      traits.add('Vocal');
    }
    if (dog.dogBasicInfo['energyLevel'] == 'High') {
      traits.add('Energetic');
    }
    return traits.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = _calculateProfileStats();
    final double profileCompletion = stats['completion'];
    final int level = stats['level'];
    final List<String> traits = _getNotableTraits();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline, width: 4),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.outline,
            offset: const Offset(6, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary, width: 3),
                  borderRadius: BorderRadius.circular(4),
                  color: theme.colorScheme.secondaryContainer,
                ),
                child: const Icon(
                  Icons.pets,
                  size: 50,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dog.name.toUpperCase(),
                      style: GoogleFonts.pressStart2p(
                        fontSize: 24,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dog.breed,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'LV. $level',
                style: GoogleFonts.pressStart2p(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('PROFILE STATUS', style: GoogleFonts.pressStart2p(fontSize: 12, color: theme.colorScheme.secondary)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: profileCompletion,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            minHeight: 12,
          ),
          const SizedBox(height: 16),
          Text('NOTABLE TRAITS', style: GoogleFonts.pressStart2p(fontSize: 12, color: theme.colorScheme.secondary)),
          const SizedBox(height: 8),
          if (traits.isNotEmpty)
            Row(
              children: traits
                  .map((trait) => Chip(
                        label: Text(trait),
                        backgroundColor: theme.colorScheme.secondaryContainer,
                      ))
                  .toList(),
            )
          else
            const Text('No notable traits identified yet.'),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(Icons.edit_note, size: 32),
              tooltip: 'Edit Dog Profile',
              onPressed: onEdit,
            ),
          )
        ],
      ),
    );
  }
}
