import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/screens/a_propos_page.dart';
import 'package:agrismart/providers/auth_provider.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final texte = Theme.of(context).textTheme;
    final email = context.select<AuthProvider, String>((a) => a.utilisateur?.email ?? '');
    final nombreZones = context.select<ZonesProvider, int>((p) => p.nombre);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          const Center(
            child: CircleAvatar(
              radius: 40,
              child: Icon(Icons.agriculture, size: 40),
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text('Exploitation AgriSmart', style: texte.titleLarge)),
          Center(child: Text(email)), // Affiche l'email
          const SizedBox(height: 16),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.grass),
            title: const Text('Zones suivies'),
            trailing: Text('$nombreZones'),
          ),

          // BOUTON DE DÉCONNEXION
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Se déconnecter', style: TextStyle(color: Colors.red)),
            onTap: () => _confirmerDeconnexion(context), // Appel de la méthode
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('À propos'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AProposPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- AJOUT DE LA MÉTHODE ICI ---
  Future<void> _confirmerDeconnexion(BuildContext context) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    // Si l'utilisateur annule ou ferme la boîte de dialogue
    if (confirme != true || !context.mounted) return;

    // On appelle la déconnexion du provider
    // (L'AuthGate s'occupera de renvoyer l'utilisateur vers l'écran de connexion)
    await context.read<AuthProvider>().deconnexion();
  }
}