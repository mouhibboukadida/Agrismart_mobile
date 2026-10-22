import 'package:flutter/material.dart';
import 'package:agrismart/data/jeu_de_donnees.dart';
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/widgets/zone_card.dart';
import 'package:agrismart/widgets/fiche_exploitation.dart';
// 1. N'OUBLIEZ PAS CET IMPORT :
import 'package:agrismart/widgets/resume_exploitation.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final List<Zone> _zones = jeuDeDonnees();

  void _modifierHumidite(Zone zone, double delta) {
    setState(() {
      zone.humidite = (zone.humidite + delta).clamp(0, 100).toDouble();
    });
  }

  Widget _carte(Zone zone) {
    return ZoneCard(
      zone: zone,
      onAugmenter: () => _modifierHumidite(zone, 5),
      onDiminuer: () => _modifierHumidite(zone, -5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('AgriSmart'),
      ),
      body: Column(
        children: [
          FicheExploitation(humiditeMoyenne: humiditeMoyenne(_zones)),

          // 2. LE NOM DE LA CLASSE PREND DES MAJUSCULES :
          ResumeExploitation(zones: _zones),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (_zones.isEmpty) {
                  return const Center(
                    child: Text('Aucune zone pour le moment'),
                  );
                }
                if (constraints.maxWidth >= 600) {
                  return GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.8,
                    ),
                    itemCount: _zones.length,
                    itemBuilder: (context, index) => _carte(_zones[index]),
                  );
                }
                return ListView.separated(
                  itemCount: _zones.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) => _carte(_zones[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} // 3. N'OUBLIEZ PAS CETTE ACCOLADE FERMANTE