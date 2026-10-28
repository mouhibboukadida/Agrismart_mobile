import 'package:flutter/material.dart';
import 'package:agrismart/data/jeu_de_donnees.dart';
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/widgets/zone_card.dart';
import 'package:agrismart/widgets/fiche_exploitation.dart';
import 'package:agrismart/widgets/resume_exploitation.dart';
import 'package:agrismart/widgets/zone_form.dart';

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
      // NOUVEAU : Appel du formulaire en mode édition au clic sur la carte
      onTap: () => _ouvrirFormulaire(zone: zone),
    );
  }

  void _ouvrirFormulaire({Zone? zone}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: ZoneForm(
              zone: zone, // On passe la zone à modifier (ou null si ajout)
              onEnregistrer: (nouvelle) {
                setState(() {
                  if (zone == null) {
                    // Mode AJOUT
                    _zones.add(nouvelle);
                  } else {
                    // Mode MODIFICATION
                    final index = _zones.indexOf(zone);
                    _zones[index] = nouvelle;
                  }
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(zone == null ? 'Zone ajoutée' : 'Zone modifiée')),
                );
              },
            ),
          ),
        );
      },
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
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) => _carte(_zones[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ouvrirFormulaire(), // Mode ajout (zone = null)
        child: const Icon(Icons.add),
      ),
    );
  }
}