import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/dog_model.dart';
import 'package:myapp/screens/survey/survey_screen.dart';
import 'package:myapp/screens/training/inventory_page.dart';
import 'package:myapp/screens/training/skill_tree_page.dart';
import 'package:myapp/screens/training/training_page.dart'; // Import is now active
import 'package:myapp/services/dog_service.dart';
import 'package:myapp/widgets/dog_id_card_widget.dart';

class MyDogsPage extends StatefulWidget {
  const MyDogsPage({super.key});

  @override
  State<MyDogsPage> createState() => _MyDogsPageState();
}

class _MyDogsPageState extends State<MyDogsPage> {
  final DogService _dogService = DogService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Dog ID Cards', style: GoogleFonts.pressStart2p(fontSize: 18)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 30),
            tooltip: 'Register a New Dog',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SurveyScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Dog>>(
        stream: _dogService.getDogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pets, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('No Digital IDs Found!', style: GoogleFonts.pressStart2p(fontSize: 16), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    const Text('Tap the \'+\' button in the top right to create a new ID.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          }

          final dogs = snapshot.data!;

          return PageView.builder(
            itemCount: dogs.length,
            itemBuilder: (context, index) {
              final dog = dogs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: DogIdCardWidget(
                  dog: dog,
                  onEdit: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SurveyScreen(dogToEdit: dog))),
                  onViewSkillTree: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SkillTreePage(dog: dog))),
                  onViewInventory: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => InventoryPage(dog: dog))),
                  onViewTraining: () {
                    // Navigation logic is now active.
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TrainingPage(dog: dog)),
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
