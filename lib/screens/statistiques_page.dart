import 'package:flutter/material.dart';
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/theme/app_theme.dart';
import 'package:agrismart/widgets/resume_exploitation.dart';

class StatistiquesPage extends StatelessWidget {
  final List<Zone> zones;

  const StatistiquesPage({super.key, required this.zones});

  @override
  Widget build(BuildContext context) {
    final tri = [...zones]..sort((a, b) => a.humidite.compareTo(b.humidite));
    final aIrriguer = zones.where((z) => z.besoinIrrigation).length;

    // TODO 1 ajoute la zone dans _zones
    final pourcentage = zones.isEmpty ? 0 : (aIrriguer * 100 / zones.length).round();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Statistiques'),
      ),
      // TODO 2 
      body: zones.isEmpty
          ? const Center(child: Text('Aucune donnée à afficher'))
          : ListView(
        children: [
          ResumeExploitation(zones: zones),
          // TODO 3
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$aIrriguer zone(s) sur ${zones.length} à irriguer ($pourcentage %)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Text('Humidité par zone', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...tri.map((z) => ListTile(
                  title: Text(z.nom),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: LinearProgressIndicator(
                      value: z.humidite / 100,
                      color: z.besoinIrrigation ? AppTheme.echec : AppTheme.succes,
                    ),
                  ),
                  trailing: Text('${z.humidite.toStringAsFixed(0)} %'),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}