import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/quest_model.dart';

class QuestCardWidget extends StatelessWidget {
  final Quest quest;
  final VoidCallback onAccept;

  const QuestCardWidget({
    super.key,
    required this.quest,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    
    // Placeholder for quest rank logic (e.g., based on reward TP)
    final int rank = (quest.rewardTp / 10).clamp(1, 5).toInt();

    return Card(
      elevation: 4,
      // Using a dark brown color to simulate a parchment/wood feel
      color: const Color(0xFF4E342E), // Brown 800
      child: InkWell(
        onTap: onAccept,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Title & Rank ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      quest.title,
                      style: GoogleFonts.pressStart2p(
                        fontSize: 18,
                        color: Colors.amber.shade200, // Gold-like color for title
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildRankStars(rank),
                ],
              ),
              const SizedBox(height: 12),

              // --- Description ---
              Text(
                quest.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade300,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.brown),

              // --- Rewards ---
              Text(
                '주요 보상',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 8),
              _buildRewards(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankStars(int rank) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rank ? Icons.star : Icons.star_border,
          color: index < rank ? Colors.amber : Colors.grey.shade600,
          size: 16,
        );
      }),
    );
  }

  Widget _buildRewards(BuildContext context) {
    final materialEntries = quest.rewardMaterials.entries.toList();
    
    return Row(
      children: [
        // TP Reward
        Chip(
          avatar: const Icon(Icons.psychology_alt, color: Colors.purpleAccent),
          label: Text('+${quest.rewardTp} TP'),
        ),
        const SizedBox(width: 8),
        // Material Rewards
        ...materialEntries.map((entry) {
          return Chip(
            avatar: const Icon(Icons.build, color: Colors.brown), // Placeholder icon
            label: Text('${entry.key.split('_').last} x${entry.value}'),
          );
        }),
      ],
    );
  }
}
