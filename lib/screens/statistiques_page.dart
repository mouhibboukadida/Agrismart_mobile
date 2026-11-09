import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/theme/app_theme.dart';
import 'package:agrismart/widgets/resume_exploitation.dart';

class StatistiquesPage extends StatelessWidget {
  // 3. SUPPRESSION du champ "final List<Zone> zones;"

  // 4. Le constructeur devient vide (plus de required this.zones)
  const StatistiquesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 5. ON ÉCOUTE LE PROVIDER ICI
    // watch : la page sera reconstruite automatiquement si les zones changent
    final zones = context.watch<ZonesProvider>().zones;

    final tri = [...zones]..sort((a, b) => a.humidite.compareTo(b.humidite));
    final aIrriguer = zones.where((z) => z.besoinIrrigation).length;

    final pourcentage = zones.isEmpty ? 0 : (aIrriguer * 100 / zones.length).round();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Statistiques'),
      ),
      body: zones.isEmpty
          ? const Center(child: Text('Aucune donnée à afficher'))
          : ListView(
        children: [
          ResumeExploitation(zones: zones),
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