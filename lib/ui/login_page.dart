import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _tourCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _tourCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(Sizes.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo et titre
                  Image.asset(
                    'assets/smartup/ibslogo/androidicons/192x192.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: Sizes.md),
                  Text(
                    'IBS Transport',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: Sizes.xl),

                  // Formulaire de connexion
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Champ Identifiant (Code de la tournée)
                        TextFormField(
                          controller: _tourCodeController,
                          decoration: InputDecoration(
                            labelText: 'Identifiant',
                            hintText: 'Code de la tournée',
                            prefixIcon: const Icon(Icons.badge),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Sizes.borderRadiusSmall),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir le code de la tournée';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Sizes.md),

                        // Champ Mot de passe
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            hintText:
                                'Défini dans le paramétrage de l\'équipe opérationnelle',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Sizes.borderRadiusSmall),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre mot de passe';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Sizes.xl),

                        // Bouton de connexion
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_passwordController.text == 'IBIS*2025*') {
                                Navigator.of(context).pushReplacementNamed('/configuration');
                              } else {
                                // Existing logic: navigate to tour page or show error
                                Navigator.of(context).pushReplacementNamed('/tour');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            padding:
                                const EdgeInsets.symmetric(vertical: Sizes.md),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Sizes.borderRadiusSmall),
                            ),
                          ),
                          child: const Text(
                            'SE CONNECTER',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        // Espace entre les boutons
                        const SizedBox(height: Sizes.md),

                        // Rangée de boutons supplémentaires
                        Row(
                          children: [
                            // Bouton Journée
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/journee');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: Sizes.md),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(Sizes.borderRadiusSmall),
                                  ),
                                ),
                                child: const Text(
                                  'JOURNÉE',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Copyright section with logo
                  const SizedBox(height: Sizes.xxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/smartup/SMART UP/Android Icons/192x192.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: Sizes.md),
                      Text(
                        '© 2025 Smart UP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Classe Sizes définie ici au cas où elle n'est pas accessible depuis device.dart
class Sizes {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
}
