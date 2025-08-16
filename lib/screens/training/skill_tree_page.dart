import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/skill_tree_database.dart';
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
  // Use a state variable that can be updated, initialized from the widget property.
  late Dog _currentDog;
  final DogService _dogService = DogService();

  @override
  void initState() {
    super.initState();
    _currentDog = widget.dog;
  }

  Future<void> _handleClassSelection(SkillClassType classType) async {
    if (_currentDog.dogClass == null && _currentDog.id != null) {
      await _dogService.chooseDogClass(_currentDog.id!, classType.name);
      // Update the local state to reflect the change immediately
      if (mounted) {
        setState(() {
          _currentDog = _currentDog.copyWith(dogClass: classType.name);
        });
      }
    }
  }

  Future<void> _handleLearnSkill(Skill skill) async {
    // Store Navigator and ScaffoldMessenger before the async gap.
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      if (_currentDog.id == null) throw Exception("Dog ID is null");
      await _dogService.spendTrainingPoints(_currentDog.id!, skill.id);

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
    if (_currentDog.dogClass == null) {
      return _buildClassSelectionUI();
    }

    final skillsOfClass = SkillTreeDatabase.getSkillsByClass(
      SkillClassType.values.byName(_currentDog.dogClass!),
    );
    final subTrees = skillsOfClass.map((s) => s.subTree).toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_currentDog.dogClass} Skill Tree',
          style: GoogleFonts.pressStart2p(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(), // Correctly calling without context
            const SizedBox(height: 24),
            // No need for .toList() when using collection spread
            ...subTrees.map((subTree) {
              final skillsInSubTree = skillsOfClass.where((s) => s.subTree == subTree).toList();
              return _buildSkillSubTree(
                title: subTree.name,
                skills: skillsInSubTree,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildClassSelectionUI() {
    return Scaffold(
      appBar: AppBar(title: Text('Choose a Class', style: GoogleFonts.pressStart2p())),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: SkillClassType.values.map((classType) {
          return Card(
            child: InkWell(
              onTap: () => _handleClassSelection(classType),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, size: 48),
                  const SizedBox(height: 8),
                  Text(classType.name, style: GoogleFonts.pressStart2p()),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Header no longer needs context passed as a parameter
  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available TP: ${_currentDog.trainingPoints}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.info_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillSubTree({required String title, required List<Skill> skills}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.pressStart2p(fontSize: 18)),
        const Divider(),
        const SizedBox(height: 16),
        Wrap(
          spacing: 24.0,
          runSpacing: 24.0,
          children: skills.map((skill) => _buildSkillIcon(skill)).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSkillIcon(Skill skill) {
    final currentLevel = _currentDog.skills[skill.id] ?? 0;
    final canLearn = _currentDog.trainingPoints >= skill.requiredTp && currentLevel < skill.maxLevel;
    
    Color borderColor = Colors.grey.shade400;
    if (currentLevel > 0) borderColor = Colors.amber;
    if (canLearn) borderColor = Colors.green;

    return GestureDetector(
      onTap: () => _showSkillDialog(skill, canLearn),
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 4),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: const Icon(Icons.star, size: 32),
          ),
          const SizedBox(height: 4),
          Text('${skill.name} [$currentLevel/${skill.maxLevel}]', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showSkillDialog(Skill skill, bool canLearn) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // Use a different context name
        return AlertDialog(
          title: Text(skill.name, style: GoogleFonts.pressStart2p()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(skill.description),
              const SizedBox(height: 16),
              Text('Required TP: ${skill.requiredTp}'),
              Text('Max Level: ${skill.maxLevel}'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Close')),
            if (canLearn)
              ElevatedButton(onPressed: () => _handleLearnSkill(skill), child: const Text('Learn')),
          ],
        );
      },
    );
  }
}
