import 'package:flutter/material.dart';

class AProposPage extends StatelessWidget {
  const AProposPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.agriculture, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'AgriSmart',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Version 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const Text(
              'AgriSmart est une application de gestion d\'exploitation agricole. '
                  'Elle permet de suivre l\'humidité des zones, de gérer l\'irrigation '
                  'et de consulter des statistiques en temps réel.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Retour'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}