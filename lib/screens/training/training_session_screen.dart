import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/models/quest_model.dart';

class TrainingSessionScreen extends StatefulWidget {
  final Dog dog;
  final Quest quest;

  const TrainingSessionScreen({super.key, required this.dog, required this.quest});

  @override
  State<TrainingSessionScreen> createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen> {
  // --- State Management ---
  double _focusLevel = 1.0;
  int _comboCount = 0;
  bool _isClickable = true;
  int _cooldownSeconds = 3;
  
  Timer? _focusTimer;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _startFocusTimer();
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  // --- Core Logic ---
  void _startFocusTimer() {
    _focusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_focusLevel > 0) {
        setState(() {
          // TODO: Link this value to dog's stats (e.g., patience)
          _focusLevel -= 0.05; 
        });
      } else {
        timer.cancel();
        _handleTrainingFailed();
      }
    });
  }

  void _onSuccessClick() {
    if (!_isClickable) return;

    setState(() {
      _isClickable = false;
      _cooldownSeconds = 3; // Reset cooldown
      _comboCount++;
      _focusLevel = (_focusLevel + 0.1).clamp(0.0, 1.0); // Restore some focus
    });

    _focusTimer?.cancel(); // Pause focus drain during cooldown

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds > 1) {
        setState(() {
          _cooldownSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isClickable = true;
        });
        _startFocusTimer(); // Resume focus drain
      }
    });
  }
  
  void _handleTrainingFailed() {
    // TODO: Navigate to LogSessionScreen with failure result
    Navigator.pop(context); // Go back for now
  }

  // --- UI Building ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.quest.title)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header UI
            _buildFocusBar(),
            const SizedBox(height: 16),
            _buildComboCounter(),
            const Spacer(),
            
            // Instruction Text
            Text(
              "강아지에게 '${widget.quest.title}' 훈련을 유도하고,\n성공하면 바로 아래 버튼을 누르세요!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Smart Clicker
            _buildSmartClicker(),
            
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusBar() { /* Placeholder */ return const SizedBox.shrink(); }
  Widget _buildComboCounter() { /* Placeholder */ return const SizedBox.shrink(); }
  Widget _buildSmartClicker() { /* Placeholder */ return const SizedBox.shrink(); }
}
