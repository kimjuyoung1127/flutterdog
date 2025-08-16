import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/item_database.dart';
import 'package:myapp/data/skill_tree_database.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/item_model.dart';
import 'package:myapp/models/skill_model.dart';

class DogIdCardWidget extends StatelessWidget {
  final Dog dog;
  final VoidCallback onEdit;
  final VoidCallback onViewSkillTree;
  final VoidCallback onViewInventory;

  const DogIdCardWidget({
    super.key,
    required this.dog,
    required this.onEdit,
    required this.onViewSkillTree,
    required this.onViewInventory,
  });

  // ... (helper methods like _calculateProfileStats remain the same)
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = _calculateProfileStats();
    final int level = stats['level'];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline, width: 4),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [ BoxShadow(color: theme.colorScheme.outline, offset: const Offset(6, 6)) ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- HEADER ---
          _buildHeader(context, level),
          const SizedBox(height: 24),

          // --- CLASS & EQUIPMENT ---
          Row(
            children: [
              Expanded(child: _buildClassInfo(context)),
              Expanded(flex: 2, child: _buildEquippedItems(context)),
            ],
          ),
          const SizedBox(height: 24),

          // --- KEY SKILLS ---
          _buildKeySkills(context),
          
          const Spacer(),

          // --- ACTION BUTTONS ---
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int level) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: const Icon(Icons.pets, size: 50),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dog.name.toUpperCase(),
                style: GoogleFonts.pressStart2p(fontSize: 24, color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                dog.breed,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        Text('LV. $level', style: GoogleFonts.pressStart2p(fontSize: 18)),
      ],
    );
  }

  Widget _buildClassInfo(BuildContext context) {
    final classType = dog.dogClass != null ? SkillClassType.values.byName(dog.dogClass!) : null;
    return Column(
      children: [
        Text("CLASS", style: GoogleFonts.pressStart2p(fontSize: 12, color: Theme.of(context).colorScheme.secondary)),
        const SizedBox(height: 8),
        Icon(_getIconForClass(classType), size: 48),
        const SizedBox(height: 4),
        Text(classType?.name ?? 'None', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEquippedItems(BuildContext context) {
    return Column(
      children: [
        Text("EQUIPMENT", style: GoogleFonts.pressStart2p(fontSize: 12, color: Theme.of(context).colorScheme.secondary)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ItemSlot.values.map((slot) {
            final itemId = dog.equippedItems[slot.name];
            final item = itemId != null ? ItemDatabase.getItemById(itemId) : null;
            return Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(item != null ? Icons.shield : Icons.help_outline, color: Colors.grey),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKeySkills(BuildContext context) {
    final sortedSkills = dog.skills.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topSkills = sortedSkills.take(4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("KEY SKILLS", style: GoogleFonts.pressStart2p(fontSize: 12, color: Theme.of(context).colorScheme.secondary)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: topSkills.map((entry) {
            final skill = SkillTreeDatabase.skills[entry.key];
            if (skill == null) return const SizedBox.shrink();
            return Chip(
              avatar: const Icon(Icons.star, size: 16),
              label: Text('${skill.name} (Lv.${entry.value})'),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildActionButtons() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined, size: 30),
            tooltip: 'View Inventory',
            onPressed: onViewInventory,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.account_tree, size: 30),
            tooltip: 'View Skill Tree',
            onPressed: onViewSkillTree,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit_note, size: 30),
            tooltip: 'Edit Dog Profile',
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  IconData _getIconForClass(SkillClassType? classType) {
    switch (classType) {
      case SkillClassType.guardian: return Icons.shield_outlined;
      case SkillClassType.sage: return Icons.book_outlined;
      case SkillClassType.ranger: return Icons.pets_outlined;
      case SkillClassType.warrior: return Icons.sports_kabaddi_outlined;
      default: return Icons.question_mark;
    }
  }
}
