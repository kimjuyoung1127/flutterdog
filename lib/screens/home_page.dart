import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/my_dogs/my_dogs_page.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('PET PARTNER', style: GoogleFonts.pressStart2p(fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async => await authService.signOut(),
          ),
        ],
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 100, color: Colors.brown),
              const SizedBox(height: 24),
              Text(
                'Ready for an Adventure?',
                style: GoogleFonts.pressStart2p(
                  fontSize: 18,
                  color: theme.colorScheme.primary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // --- Main action buttons ---
              _buildMainMenuButton(
                context,
                icon: Icons.credit_card,
                label: '내 강아지 프로필',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyDogsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildMainMenuButton(
                context,
                icon: Icons.map_outlined,
                label: '산책 시작하기',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('산책 기능은 곧 추가될 예정입니다!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28),
      label: Text(label, style: GoogleFonts.pressStart2p(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: const Size(double.infinity, 60),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
      onPressed: onPressed,
    );
  }
}
