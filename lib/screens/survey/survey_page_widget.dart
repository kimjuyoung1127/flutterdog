import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SurveyPageWidget extends StatelessWidget {
  final String pageTitle;
  final Widget child;
  final VoidCallback onNext;
  final VoidCallback? onSaveAndExit; // Optional callback for the new button
  final bool isLastPage;

  const SurveyPageWidget({
    super.key,
    required this.pageTitle,
    required this.child,
    required this.onNext,
    this.onSaveAndExit, // Make it available in the constructor
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            pageTitle,
            style: GoogleFonts.pressStart2p(
              fontSize: 22,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: child,
            ),
          ),
          const SizedBox(height: 24),
          // Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Show "Save & Exit" button if the callback is provided and it's not the last page
              if (onSaveAndExit != null && !isLastPage)
                TextButton(
                  onPressed: onSaveAndExit,
                  child: const Text('Save & Exit'),
                ),
              const SizedBox(width: 16),
              // Main action button (Next or Submit)
              ElevatedButton(
                onPressed: onNext,
                child: Text(isLastPage ? 'Save Profile' : 'Next Step'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
