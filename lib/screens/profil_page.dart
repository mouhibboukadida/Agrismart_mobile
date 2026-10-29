import 'package:flutter/material.dart';
import 'package:agrismart/screens/a_propos_page.dart';

class ProfilPage extends StatelessWidget {
  final int nombreZones;

  const ProfilPage({super.key, required this.nombreZones});

  @override
  Widget build(BuildContext context) {
    final texte = Theme.of(context).textTheme;
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

          // LIGNE EXISTANTE :
          ListTile(
            leading: const Icon(Icons.grass),
            title: const Text('Zones suivies'),
            trailing: Text('$nombreZones'),
          ),

          // NOUVELLE LIGNE POUR L'EXERCICE 2 :
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