import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- 1. IMPORT PROVIDER
import 'package:agrismart/providers/zones_provider.dart'; // <-- 2. IMPORT DU PROVIDER
import 'package:agrismart/screens/a_propos_page.dart';

class ProfilPage extends StatelessWidget {
  // 3. SUPPRESSION de "final int nombreZones;"

  // 4. Constructeur vide
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final texte = Theme.of(context).textTheme;

    // 5. SELECT : on écoute uniquement le nombre de zones
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
          const Center(child: Text('Kébili, Tunisie')),
          const SizedBox(height: 16),
          const Divider(),

          // LIGNE EXISTANTE (utilise maintenant la variable du provider)
          ListTile(
            leading: const Icon(Icons.grass),
            title: const Text('Zones suivies'),
            trailing: Text('$nombreZones'),
          ),

          // TON BOUTON "À PROPOS" (inchangé)
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
}