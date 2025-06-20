import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/MonApplication.dart';

import 'loginControl.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tryAutoLogin();


    _emailController.addListener(_clearError);
    _passwordController.addListener(_clearError);
  }

  void _clearError() {
    final notifier = ref.read(loginControlProvider.notifier);
    if (ref.read(loginControlProvider).errorMsg != null) {
      notifier.state = notifier.state.copyWith(errorMsg: null);
      setState(() {});
    }
  }


  Future<void> _tryAutoLogin() async {
    final success = await ref.read(loginControlProvider.notifier).tryAutoLogin();
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MonApplication()),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControlProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Logo et titre
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFE53935),
                      child: Icon(Icons.event, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'EventPro',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connexion',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Section de connexion
              Text(
                'Connectez-vous',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Entrez vos identifiants pour accéder à votre compte',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // 🔁 AJOUT : affichage du message d’erreur
              if (state.errorMsg != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Center(
                    child: Text(
                      state.errorMsg!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                ),

              // Formulaire
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Champ email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'votre@email.com',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email';
                        }
                        if (!value.contains('@')) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Champ mot de passe
                    TextFormField(
                      controller: _passwordController,
                      onChanged: (_) => _clearError(),
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: '••••••',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Se souvenir de moi + mot de passe oublié
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: state.rememberMe,
                              onChanged: (value) {
                                ref.read(loginControlProvider.notifier)
                                    .toggleRememberMe(value ?? false);
                              },
                            ),
                            Text(
                              'Se souvenir de moi',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Implémenter la récupération de mot de passe
                          },
                          child: Text(
                            'Mot de passe oublié ?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Bouton de connexion
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (state.isLoading && !state.isAutoLoginLoading)
                            ? null
                            : () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await ref
                                .read(loginControlProvider.notifier)
                                .login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            if (success && mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MonApplication(),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: (state.isLoading && !state.isAutoLoginLoading)
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          'Se connecter',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Séparateur
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'ou',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Bouton Google
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implémenter la connexion Google
                        },
                        label: const Text('Continuer avec Google'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Lien vers l'inscription
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/register');
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Pas encore de compte ? ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                            children: [
                              TextSpan(
                                text: 'Créer un compte',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFFE53935),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
