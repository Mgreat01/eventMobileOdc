import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'otpController.dart';
import 'otpState.dart';
import '../auth/loginPage.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  ConsumerState<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Solution : décaler la modification de provider après build
    Future.microtask(() {
      ref.read(otpVerificationProvider.notifier).initEmail(widget.email);
    });
  }


  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpVerificationProvider);
    final controller = ref.read(otpVerificationProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Icon(Icons.email, size: 100, color: Color(0xFF6C63FF)),
              const SizedBox(height: 24),
              Text(
                'Vérification de l\'adresse email',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Un code a été envoyé à ${widget.email}'),
              const SizedBox(height: 32),

              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Code OTP',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : () => _submitOtp(controller),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Vérifier'),
                ),
              ),
              const SizedBox(height: 16),

              if (state.error != null)
                Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                ),

              // Bouton de renvoi désactivé car non encore implémenté :
              // TextButton(
              //   onPressed: () => controller.resendOtp(widget.email),
              //   child: const Text('Renvoyer le code'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitOtp(OtpVerificationControl controller) async {
    if (_formKey.currentState!.validate()) {
      final success = await controller.verifyOtp(_otpController.text.trim());
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vérification réussie')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
  }
}
