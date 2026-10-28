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
      onTap: () => _ouvrirFormulaire(zone: zone),
      // EXERCICE 2 : Ajout de l'appui long pour supprimer
      onLongPress: () => _confirmerSuppression(zone),
    );
  }

  void _ouvrirFormulaire({Zone? zone}) {
    // EXERCICE 1 : On prépare la liste des noms existants en excluant la zone actuelle
    final nomsExistants = _zones
        .where((z) => z.nom != zone?.nom)
        .map((z) => z.nom)
        .toList();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: ZoneForm(
              zone: zone,
              nomsExistants: nomsExistants, // On passe la liste au formulaire
              onEnregistrer: (nouvelle) {
                setState(() {
                  if (zone == null) {
                    _zones.add(nouvelle);
                  } else {
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

  // EXERCICE 2 : Boîte de dialogue pour confirmer la suppression
  Future<void> _confirmerSuppression(Zone zone) async {
    final bool? reponse = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la zone'),
        content: Text('Supprimer la zone ${zone.nom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false), // Annuler
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), // Confirmer
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (reponse == true) {
      setState(() {
        _zones.remove(zone);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zone supprimée')),
      );
    }
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
        onPressed: () => _ouvrirFormulaire(),
        child: const Icon(Icons.add),
      ),
    );
  }
}