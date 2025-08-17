import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/material_database.dart';
import 'package:myapp/models/dog_model.dart'; // Import Dog model
import 'package:myapp/models/quest_model.dart';
import 'package:myapp/screens/training/training_session_screen.dart'; // Import the session screen

class QuestDetailScreen extends StatelessWidget {
  final Dog dog; // Dog object is now required to pass to the next screen
  final Quest quest;

  const QuestDetailScreen({super.key, required this.dog, required this.quest});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        title: Text('Quest Briefing', style: GoogleFonts.pressStart2p()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDE7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFD2B48C), width: 3),
                    ),
                  ),
                  Positioned(
                    top: -10,
                    left: 0,
                    right: 0,
                    child: Icon(Icons.push_pin, size: 40, color: Colors.brown.shade800),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(quest.title, style: GoogleFonts.pressStart2p(fontSize: 22, color: Colors.brown.shade900)),
                        const SizedBox(height: 16),
                        Text(quest.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                        const Divider(height: 32),
                        Text("획득 가능 재료", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _buildRewardItems(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.amber.shade700,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                // --- NAVIGATION LOGIC ADDED HERE ---
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TrainingSessionScreen(dog: dog, quest: quest),
                  ),
                );
              },
              child: Text('퀘스트 수주!', style: GoogleFonts.pressStart2p(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItems() {
    final materialEntries = quest.rewardMaterials.entries.toList();
    if (materialEntries.isEmpty) {
      return const Text("특별한 보상 없음");
    }

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: materialEntries.map((entry) {
        final material = MaterialDatabase.getMaterialById(entry.key);
        if (material == null) return const SizedBox.shrink();

        return Chip(
          avatar: const Icon(Icons.build, size: 18),
          label: Text('${material.name} x${entry.value}'),
        );
      }).toList(),
    );
  }
}
