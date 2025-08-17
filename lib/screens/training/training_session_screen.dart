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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Training Paused'),
        content: const Text('What would you like to do?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isPaused = false);
              _startFocusTimer();
            },
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Give Up Training'),
          ),
        ],
      ),
    );
  }

  void _handleTrainingSuccess() { /* TODO: Navigate to LogSessionScreen */ }
  void _handleTrainingFailed() { /* TODO: Navigate to LogSessionScreen */ }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(widget.quest.title, style: GoogleFonts.pressStart2p(fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _showPauseDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildStaminaBar(),
            const SizedBox(height: 16),
            _buildSuccessAndChainCounter(),
            const SizedBox(height: 32),
            _buildInstructorDialogue(),
            const Spacer(),
            _buildMagicCircleClicker(),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildStaminaBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("기력 (Stamina)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          height: 25,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _focusLevel,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        )
      ],
    );
  }
  
  Widget _buildSuccessAndChainCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '성공: $_successCount / $_goalCount',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
          child: Text(
            '$_comboCount CHAIN!',
            key: ValueKey<int>(_comboCount),
            style: GoogleFonts.pressStart2p(fontSize: 28, color: Colors.amber),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructorDialogue() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "훈련 교관: 파트너에게 '${widget.quest.title}'을(를) 유도하게!",
        style: const TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic, height: 1.5),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMagicCircleClicker() {
    return GestureDetector(
      onTap: _onSuccessClick,
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
    return Container(
      key: const ValueKey('active'),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: Colors.cyanAccent, width: 2),
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.cyan)
        ]
      ),
      child: Center(
        child: Text("TAP!", style: GoogleFonts.pressStart2p(fontSize: 32, color: Colors.cyanAccent)),
      ),
    );
  }

  Widget _buildCooldownMagicCircle() {
    return Stack(
      key: const ValueKey('cooldown'),
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 180, width: 180,
          child: CircularProgressIndicator(
            value: 1.0 - ((_cooldownAnimationController?.value ?? 0)),
            strokeWidth: 4,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
            backgroundColor: Colors.grey.withOpacity(0.3),
          ),
        ),
        Text("$_cooldownSeconds", style: GoogleFonts.pressStart2p(fontSize: 32, color: Colors.grey)),
      ],
    );
  }
}
