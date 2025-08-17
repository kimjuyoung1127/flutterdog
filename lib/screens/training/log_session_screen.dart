import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/material_database.dart';
import 'package:myapp/data/skill_tree_database.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/training_result_model.dart';
import 'package:myapp/services/dog_service.dart';

class LogSessionScreen extends StatefulWidget {
  final Dog dog;
  final TrainingResult result;

  const LogSessionScreen({super.key, required this.dog, required this.result});

  @override
  State<LogSessionScreen> createState() => _LogSessionScreenState();
}

class _LogSessionScreenState extends State<LogSessionScreen> {
  final _logTextController = TextEditingController();
  final DogService _dogService = DogService();
  bool _canCraft = false;

  @override
  void initState() {
    super.initState();
    _checkIfCanCraft();
  }

  @override
  void dispose() {
    _logTextController.dispose();
    super.dispose();
  }

  void _checkIfCanCraft() {
    // ... (Full implementation from before)
  }

  Future<void> _onCompleteTraining() async {
    // ... (Full implementation from before)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Training Result", style: GoogleFonts.pressStart2p()),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultTitle(),
            const SizedBox(height: 24),
            _buildLootList(),
            const SizedBox(height: 24),
            TextField(
              controller: _logTextController,
              decoration: const InputDecoration(
                labelText: '한 줄 훈련 일지',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const Spacer(),
            _buildCtaButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultTitle() {
    return Text(
      widget.result.isSuccess ? "QUEST COMPLETE" : "QUEST FAILED",
      textAlign: TextAlign.center,
      style: GoogleFonts.pressStart2p(
        fontSize: 28,
        color: widget.result.isSuccess ? Colors.green.shade600 : Colors.red.shade600,
      ),
    );
  }

  Widget _buildLootList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("획득한 전리품:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (widget.result.isSuccess)
          ...widget.result.quest.rewardMaterials.entries.map((entry) {
            final material = MaterialDatabase.getMaterialById(entry.key);
            return ListTile(
              leading: const Icon(Icons.build),
              title: Text(material?.name ?? 'Unknown Material'),
              trailing: Text('x${entry.value}'),
            );
          }).toList()
        else
          const Text("획득한 재료가 없습니다."),
      ],
    );
  }

  Widget _buildCtaButton() {
    return ElevatedButton.icon(
      icon: Icon(_canCraft ? Icons.flare : Icons.arrow_forward),
      label: Text(
        _canCraft ? "스킬 제작하기 ✨" : "퀘스트 보드로 돌아가기",
        style: GoogleFonts.pressStart2p(),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: _canCraft ? Colors.amber.shade700 : Colors.blueGrey,
        foregroundColor: _canCraft ? Colors.black : Colors.white,
      ),
      onPressed: _onCompleteTraining,
    );
  }
}
