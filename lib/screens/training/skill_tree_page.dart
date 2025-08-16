import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package.myapp/data/skill_tree_database.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/skill_model.dart';
import 'package:myapp/services/dog_service.dart';

class SkillTreePage extends StatefulWidget {
  final Dog dog;

  const SkillTreePage({super.key, required this.dog});

  @override
  State<SkillTreePage> createState() => _SkillTreePageState();
}

class _SkillTreePageState extends State<SkillTreePage> {
  late Dog _currentDog;
  final DogService _dogService = DogService();

  @override
  void initState() {
    super.initState();
    _currentDog = widget.dog;
  }
  
  Future<void> _handleClassSelection(SkillClassType classType) async {
    // ... implementation ...
  }

  // Updated to use the new service method
  Future<void> _handleLearnSkill(Skill skill) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      if (_currentDog.id == null) throw Exception("Dog ID is null");
      // Call the new material-based learning method
      await _dogService.learnSkillWithMaterials(_currentDog.id!, skill.id);

      if (mounted) {
        navigator.pop(); // Close the dialog
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('${skill.name} learned!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        navigator.pop(); // Close the dialog
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to learn skill: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... build method ...
  }
  
  // ... other build UI methods ...

  Widget _buildSkillIcon(Skill skill) {
    final currentLevel = _currentDog.skills[skill.id] ?? 0;
    // Updated logic to check for materials instead of TP
    final canLearn = _canAfford(skill) && currentLevel < skill.maxLevel;
    
    // ... rest of the buildSkillIcon method ...
  }

  // New helper method to check if the dog has enough materials
  bool _canAfford(Skill skill) {
    for (var entry in skill.craftingMaterials.entries) {
      if ((_currentDog.inventory[entry.key] ?? 0) < entry.value) {
        return false;
      }
    }
    return true;
  }

  void _showSkillDialog(Skill skill, bool canLearn) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(skill.name, style: GoogleFonts.pressStart2p()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(skill.description),
              const SizedBox(height: 16),
              // Show required materials instead of TP
              Text('Required Materials: ${skill.craftingMaterials}'),
              Text('Max Level: ${skill.maxLevel}'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Close')),
            if (canLearn)
              ElevatedButton(onPressed: () => _handleLearnSkill(skill), child: const Text('Craft Skill')),
          ],
        );
      },
    );
  }
}
