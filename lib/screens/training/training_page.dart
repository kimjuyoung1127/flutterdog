import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/quest_model.dart';
import 'package:myapp/services/ai_service.dart';

class TrainingPage extends StatefulWidget {
  final Dog dog;

  const TrainingPage({super.key, required this.dog});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  final AIService _aiService = AIService();
  late Future<List<Quest>> _questsFuture;

  @override
  void initState() {
    super.initState();
    _questsFuture = _aiService.generateQuests(dog: widget.dog);
  }

  void _regenerateQuests() {
    setState(() {
      _questsFuture = _aiService.generateQuests(dog: widget.dog);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.dog.name}\'s Quests', style: GoogleFonts.pressStart2p()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Regenerate Quests',
            onPressed: _regenerateQuests,
          ),
        ],
      ),
      body: FutureBuilder<List<Quest>>(
        future: _questsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to generate quests: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No quests available.'));
          }

          final quests = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: quests.length,
            itemBuilder: (context, index) {
              final quest = quests[index];
              // Displaying rewardMaterials instead of rewardTp
              final rewardsText = quest.rewardMaterials.entries
                  .map((e) => '${e.key} x${e.value}')
                  .join(', ');

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.article_outlined, color: Colors.amber),
                  title: Text(quest.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(quest.description),
                  trailing: Text(rewardsText, style: const TextStyle(fontSize: 12)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
