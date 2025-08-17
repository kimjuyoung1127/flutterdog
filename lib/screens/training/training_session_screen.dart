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

class _TrainingSessionScreenState extends State<TrainingSessionScreen> with TickerProviderStateMixin {
  // --- State Management ---
  int _successCount = 0;
  final int _goalCount = 5;
  double _focusLevel = 1.0;
  int _comboCount = 0;
  bool _isClickable = true;
  int _cooldownSeconds = 3;
  bool _isPaused = false;
  
  Timer? _focusTimer;
  Timer? _cooldownTimer;
  AnimationController? _cooldownAnimationController;

  @override
  void initState() {
    super.initState();
    _startFocusTimer();
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    _cooldownTimer?.cancel();
    _cooldownAnimationController?.dispose();
    super.dispose();
  }

  // --- Core Logic (with pause/resume functionality) ---
  void _startFocusTimer() {
    if (_isPaused) return;
    _focusTimer?.cancel();
    _focusTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_focusLevel > 0) {
        setState(() => _focusLevel -= 0.005);
      } else {
        timer.cancel();
        _handleTrainingFailed();
      }
    });
  }

  void _onSuccessClick() {
    if (!_isClickable) return;
    
    _focusTimer?.cancel();

    setState(() {
      _isClickable = false;
      _cooldownSeconds = 3;
      _comboCount++;
      _successCount++;
      _focusLevel = (_focusLevel + 0.2).clamp(0.0, 1.0);
    });
    
    _cooldownAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..forward();

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds > 1) {
        setState(() => _cooldownSeconds--);
      } else {
        timer.cancel();
        if (_successCount >= _goalCount) {
          _handleTrainingSuccess();
        } else {
          setState(() => _isClickable = true);
          _startFocusTimer();
        }
      }
    });
  }
  
  void _showPauseDialog() {
    setState(() => _isPaused = true);
    _focusTimer?.cancel();
    _cooldownTimer?.cancel();

    showDialog(context: context, builder: (context) => AlertDialog(/* ... */));
  }
  
  void _handleTrainingSuccess() { /* ... */ }
  void _handleTrainingFailed() { /* ... */ }

  // --- UI Building ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... (Scaffold and AppBar from before)
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // ... (Header UI from before)
            const Spacer(),
            _buildInstructorDialogue(),
            const Spacer(),
            _buildMagicCircleClicker(), // This is the widget to update
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
  
  // ... (Other build helpers: _buildStaminaBar, _buildChainCounter, _buildInstructorDialogue)
  
  Widget _buildMagicCircleClicker() {
    return GestureDetector(
      onTap: _onSuccessClick, // Logic is now connected
      child: SizedBox(
        height: 180,
        width: 180,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isClickable
              ? _buildActiveMagicCircle()
              : _buildCooldownMagicCircle(),
        ),
      ),
    );
  }

  Widget _buildActiveMagicCircle() {
    return Center(
      key: const ValueKey('active'),
      child: Text(
        "TAP!",
        style: GoogleFonts.pressStart2p(
          fontSize: 32,
          color: Colors.cyanAccent,
          shadows: [const Shadow(blurRadius: 20, color: Colors.cyan)]
        ),
      ),
    );
  }

  Widget _buildCooldownMagicCircle() {
    return Stack(
      key: const ValueKey('cooldown'),
      alignment: Alignment.center,
      children: [
        // Animated circular border for cooldown
        AnimatedBuilder(
          animation: _cooldownAnimationController!,
          builder: (context, child) {
            return CircularProgressIndicator(
              value: _cooldownAnimationController!.value,
              strokeWidth: 10,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
              backgroundColor: Colors.grey.withOpacity(0.3),
            );
          },
        ),
        Text(
          "$_cooldownSeconds",
          style: GoogleFonts.pressStart2p(fontSize: 32, color: Colors.grey),
        ),
      ],
    );
  }
}
