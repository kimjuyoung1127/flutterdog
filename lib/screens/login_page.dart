import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  // This function now handles the anonymous sign-in for development
  Future<void> _devSignIn(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    _isLoading.value = true;
    try {
      // Call the new anonymous sign-in method
      await authService.signInAnonymously();
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Developer sign-in failed. Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        _isLoading.value = false;
      }
    }
  }
  
  // The original Google sign-in function is kept for later use
  Future<void> _signInWithGoogle(BuildContext context) async {
    // ... (original code remains here, commented out or unused for now)
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 100, color: Colors.brown),
              const SizedBox(height: 24),
              Text(
                'PET PARTNER',
                style: GoogleFonts.pressStart2p(
                  fontSize: 28,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                builder: (context, isLoading, child) {
                  if (isLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton.icon(
                    icon: const Icon(Icons.flash_on, size: 32), // Changed icon for dev mode
                    label: Text('빠른 시작 (개발용)', style: GoogleFonts.pressStart2p(fontSize: 16)),
                    onPressed: () => _devSignIn(context), // Switched to the dev sign-in function
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: theme.colorScheme.secondary, // Changed color for dev mode
                      minimumSize: const Size(double.infinity, 60),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
