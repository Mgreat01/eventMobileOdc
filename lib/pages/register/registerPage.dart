import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/pages/register/registerControl.dart';
import 'package:odc_mobile_template/pages/register/registerState.dart';
import 'package:odc_mobile_template/pages/auth/loginPage.dart';

import '../otp/otpPage.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _orgController = TextEditingController();
  String _selectedRole = 'public';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _orgController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(registerControlProvider.notifier).loadInterets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerControlProvider);
    final controller = ref.read(registerControlProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF6C63FF),
                      child: Icon(Icons.event, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text('EventPro',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    const SizedBox(height: 8),
                    Text('Créer un compte',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _buildTextField(
                controller: _nameController,
                label: 'Nom complet',
                icon: Icons.person,
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                validator: (v) =>
                !v!.contains('@') ? 'Email invalide' : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _passwordController,
                label: 'Mot de passe',
                icon: Icons.lock,
                obscure: true,
                validator: (v) =>
                v!.length < 6 ? 'Au moins 6 caractères' : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Confirmer le mot de passe',
                icon: Icons.lock_outline,
                obscure: true,
                validator: (v) =>
                v != _passwordController.text ? 'Mots de passe différents' : null,
              ),
              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Rôle',
                  prefixIcon: Icon(Icons.people),
                ),
                items: const [
                  DropdownMenuItem(value: 'public', child: Text('Public')),
                  DropdownMenuItem(value: 'organisateur', child: Text('Organisateur')),
                ],
                onChanged: (value) {
                  setState(() => _selectedRole = value ?? 'public');
                },
              ),
              const SizedBox(height: 16),

              if (_selectedRole == 'organisateur')
                _buildTextField(
                  controller: _orgController,
                  label: 'Nom de l\'organisation',
                  icon: Icons.business,
                  validator: (v) =>
                  _selectedRole == 'organisateur' && v!.isEmpty
                      ? 'Champ requis'
                      : null,
                ),

              if (_selectedRole == 'public') ...[
                const SizedBox(height: 16),
                Text('Centres d\'intérêt (max 3)', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                if (state.allInteretsFull.isEmpty)
                  const CircularProgressIndicator()
                else
                  Wrap(
                    spacing: 8,
                    children: state.allInteretsFull.map((interest) {
                      final isSelected =
                      state.selectedInterestIds.contains(interest.id);
                      return ChoiceChip(
                        label: Text(interest.nom),
                        selected: isSelected,
                        onSelected: (_) =>
                            controller.toggleInterest(interest.id),
                        selectedColor: const Color(0xFF6C63FF).withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? const Color(0xFF6C63FF)
                              : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
              ],

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('S\'inscrire'),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  child: const Text('Déjà un compte ? Se connecter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(registerControlProvider.notifier);
      final success = await controller.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        role: _selectedRole,
        organizationName: _selectedRole == 'organisateur'
            ? _orgController.text.trim()
            : null,
        interests: _selectedRole == 'public'
            ? ref.read(registerControlProvider).selectedInterestIds
            : null,
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
            MaterialPageRoute(
              builder: (_) => OtpVerificationPage(email:  _emailController.text.trim()),
            ),
        );
      } else if (mounted) {
        final error = // ref.read(registerControlProvider).error ??
            'Erreur lors de l\'inscription';
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Échec de l\'inscription'),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Fermer'),
              ),
            ],
          ),
        );
      }
    }
  }

}
