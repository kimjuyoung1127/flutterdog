import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/providers/survey_provider.dart';
import 'package:myapp/screens/survey/pages/dog_info/dog_basic_info_page.dart';
import 'package:myapp/screens/survey/pages/dog_info/dog_health_page.dart';
import 'package:myapp/screens/survey/pages/dog_routine_page.dart';
import 'package:myapp/screens/survey/pages/guardian_info_page.dart';
import 'package:myapp/screens/survey/pages/problem_behaviors_page.dart';
import 'package:myapp/screens/survey/pages/training_goals_page.dart';
import 'package:myapp/screens/survey/survey_page_widget.dart';
import 'package:myapp/services/dog_service.dart';
import 'package:provider/provider.dart';

class SurveyScreen extends StatefulWidget {
  final Dog? dogToEdit;

  const SurveyScreen({super.key, this.dogToEdit});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final PageController _pageController = PageController();
  final int _totalPages = 6;
  double _progress = 1 / 6;

  bool get _isEditMode => widget.dogToEdit != null;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        // Use .toInt() to prevent issues during page transitions
        _progress = (_pageController.page!.toInt() + 1) / _totalPages;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  // The context is passed explicitly to ensure the correct one is used.
  Future<void> _submitSurvey(BuildContext context, SurveyProvider surveyProvider) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Error: You must be logged in.'), backgroundColor: Colors.red),
      );
      return;
    }

    final String? dogId = _isEditMode ? widget.dogToEdit?.id : null;
    
    final success = await surveyProvider.submitSurvey(
      userId: user.uid,
      dogId: dogId, 
      isEditMode: _isEditMode
    );

    if (!mounted) return;

    if (success) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Profile ${_isEditMode ? "updated" : "saved"} successfully!'), backgroundColor: Colors.green),
      );
      // This pop will now execute correctly.
      navigator.pop();
    } else {
       scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to save profile: ${surveyProvider.errorMessage}'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SurveyProvider(DogService())..loadInitialData(widget.dogToEdit),
      child: Consumer<SurveyProvider>(
        builder: (consumerContext, surveyProvider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                _isEditMode ? 'Edit Pet Profile' : 'New Pet Profile',
                style: GoogleFonts.pressStart2p(fontSize: 18),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                // Directly pass the lambda with the builder's context
                SurveyPageWidget(pageTitle: "Guardian's Info", onNext: _nextPage, onSaveAndExit: () => _submitSurvey(consumerContext, surveyProvider), child: const GuardianInfoPage()),
                SurveyPageWidget(pageTitle: "Dog's Basic Info", onNext: _nextPage, onSaveAndExit: () => _submitSurvey(consumerContext, surveyProvider), child: const DogBasicInfoPage()),
                SurveyPageWidget(pageTitle: "Dog's Health", onNext: _nextPage, onSaveAndExit: () => _submitSurvey(consumerContext, surveyProvider), child: const DogHealthPage()),
                SurveyPageWidget(pageTitle: "Dog's Routine", onNext: _nextPage, onSaveAndExit: () => _submitSurvey(consumerContext, surveyProvider), child: const DogRoutinePage()),
                SurveyPageWidget(pageTitle: "Problem Behaviors", onNext: _nextPage, onSaveAndExit: () => _submitSurvey(consumerContext, surveyProvider), child: const ProblemBehaviorsPage()),
                SurveyPageWidget(pageTitle: "Training Goals", onNext: () => _submitSurvey(consumerContext, surveyProvider), isLastPage: true, child: const TrainingGoalsPage()),
              ],
            ),
          );
        },
      ),
    );
  }
}
