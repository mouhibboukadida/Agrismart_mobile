import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/providers/auth_provider.dart';
import 'package:agrismart/screens/inscription_page.dart';

String? validerEmail(String? valeur) {
  final v = (valeur ?? '').trim();
  if (v.isEmpty) return "L'email est obligatoire";
  final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
  if (!ok) return 'Email invalide';
  return null;
}

String? validerMotDePasse(String? valeur) {
  if (valeur == null || valeur.isEmpty) return 'Le mot de passe est obligatoire';
  if (valeur.length < 6) return '6 caractères minimum';
  return null;
}

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _mdpCtrl = TextEditingController();
  bool _masquer = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _mdpCtrl.dispose();
    super.dispose();
  }

  Future<void> _connecter() async {
    if (!_formKey.currentState!.validate()) return;
    await context
        .read<AuthProvider>()
        .connexion(_emailCtrl.text, _mdpCtrl.text);
    // succes : AuthGate affiche l'application tout seul
  }

  Future<void> _motDePasseOublie() async {
    final email = _emailCtrl.text;
    if (validerEmail(email) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saisissez d'abord votre email")),
      );
      return;
    }
    final ok =
    await context.read<AuthProvider>().reinitialiserMotDePasse(email);
    if (!ok || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email de réinitialisation envoyé')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.agriculture, size: 64),
                    const SizedBox(height: 8),
                    Text('AgriSmart',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: validerEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mdpCtrl,
                      obscureText: _masquer,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_masquer
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(() => _masquer = !_masquer),
                        ),
                      ),
                      validator: validerMotDePasse,
                    ),
                    if (auth.erreur != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        auth.erreur!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: auth.occupe ? null : _connecter,
                      child: auth.occupe
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Se connecter'),
                    ),
                    TextButton(
                      onPressed: auth.occupe ? null : _motDePasseOublie,
                      child: const Text('Mot de passe oublié ?'),
                    ),
                    TextButton(
                      onPressed: auth.occupe
                          ? null
                          : () {
                        context.read<AuthProvider>().effacerErreur();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InscriptionPage(),
                          ),
                        );
                      },
                      child: const Text("Pas de compte ? S'inscrire"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
