import 'package:flutter/material.dart';
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/screens/zone_detail_page.dart';
import 'package:agrismart/screens/zone_form_page.dart';
import 'package:agrismart/widgets/fiche_exploitation.dart';
import 'package:agrismart/widgets/resume_exploitation.dart';
import 'package:agrismart/widgets/zone_card.dart';

class ZonesPage extends StatelessWidget {
  final List<Zone> zones;
  final void Function(Zone zone, double delta) onModifierHumidite;
  final void Function(Zone zone) onAjouter;
  final void Function(Zone ancienne, Zone nouvelle) onRemplacer;
  final void Function(Zone zone) onSupprimer;

  const ZonesPage({
    super.key,
    required this.zones,
    required this.onModifierHumidite,
    required this.onAjouter,
    required this.onRemplacer,
    required this.onSupprimer,
  });

  List<String> _noms({Zone? sauf}) {
    return zones.where((z) => z != sauf).map((z) => z.nom).toList();
  }

  void _message(BuildContext context, String texte) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texte)));
  }

  Future<void> _ajouter(BuildContext context) async {
    final nouvelle = await Navigator.push<Zone>(
      context,
      MaterialPageRoute(
        builder: (_) => ZoneFormPage(nomsExistants: _noms()),
      ),
    );
    if (nouvelle == null || !context.mounted) return;
    onAjouter(nouvelle);
    _message(context, 'Zone ajoutée');
  }

  Future<void> _ouvrirDetail(BuildContext context, Zone zone) async {
    final modifiee = await Navigator.push<Zone>(
      context,
      MaterialPageRoute(
        builder: (_) => ZoneDetailPage(
          zone: zone,
          nomsAutres: _noms(sauf: zone),
        ),
      ),
    );
    if (modifiee == null || !context.mounted) return;
    onRemplacer(zone, modifiee);
    _message(context, 'Zone modifiée');
  }

  Future<void> _confirmerSuppression(BuildContext context, Zone zone) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la zone ?'),
        content: Text('La zone "${zone.nom}" sera supprimée définitivement.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme != true || !context.mounted) return;
    onSupprimer(zone);
    _message(context, 'Zone supprimée');
  }

  Widget _carte(BuildContext context, Zone zone) {
    return ZoneCard(
      zone: zone,
      onAugmenter: () => onModifierHumidite(zone, 5),
      onDiminuer: () => onModifierHumidite(zone, -5),
      onTap: () => _ouvrirDetail(context, zone),
      onLongPress: () => _confirmerSuppression(context, zone),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('AgriSmart'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ajouter(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          FicheExploitation(humiditeMoyenne: humiditeMoyenne(zones)),
          ResumeExploitation(zones: zones),
          Expanded(
            child: zones.isEmpty
                ? const Center(child: Text('Aucune zone pour le moment'))
                : LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 600) {
                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.8,
                    ),
                    itemCount: zones.length,
                    itemBuilder: (context, index) => _carte(context, zones[index]),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: zones.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => _carte(context, zones[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}