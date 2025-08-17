import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/quest_model.dart';
import 'package:myapp/screens/training/quest_detail_screen.dart'; // Import the detail screen
import 'package:myapp/services/mock_ai_service.dart';
import 'package:myapp/widgets/quest_card_widget.dart';

class TrainingPage extends StatefulWidget {
  final Dog dog;

  const TrainingPage({super.key, required this.dog});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  final MockAIService _aiService = MockAIService(); 
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
      backgroundColor: const Color(0xFFD7CCC8), 
      appBar: AppBar(
        title: Text('${widget.dog.name}\'s Quests', style: GoogleFonts.pressStart2p()),
        backgroundColor: const Color(0xFF4E342E),
        foregroundColor: Colors.white,
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('AI가 새로운 의뢰를 찾고 있습니다...'),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('의뢰를 받는 데 실패했습니다: ${snapshot.error}'),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('수주할 의뢰가 없습니다.'));
          }

          final quests = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: quests.length,
            itemBuilder: (context, index) {
              final quest = quests[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: QuestCardWidget(
                  quest: quest,
                  onAccept: () {
                    // --- NAVIGATION LOGIC ADDED HERE ---
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuestDetailScreen(quest: quest),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
