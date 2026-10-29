import 'package:flutter/material.dart';

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
          ListTile(
            leading: const Icon(Icons.grass),
            title: const Text('Zones suivies'),
            trailing: Text('$nombreZones'),
          ),
        ],
      ),
    );
  }
}