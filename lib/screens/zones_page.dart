import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- 1. IMPORT PROVIDER
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/providers/zones_provider.dart'; // <-- 2. IMPORT DU PROVIDER
import 'package:agrismart/screens/zone_detail_page.dart';
import 'package:agrismart/screens/zone_form_page.dart';
import 'package:agrismart/widgets/fiche_exploitation.dart';
import 'package:agrismart/widgets/resume_exploitation.dart';
import 'package:agrismart/widgets/zone_card.dart';

class ZonesPage extends StatelessWidget {
  // 3. SUPPRESSION DE TOUS LES CHAMPS (zones, onModifierHumidite, etc.)

  // 4. LE CONSTRUCTEUR DEVIENT VIDE
  const ZonesPage({super.key});

  // 5. SUPPRESSION DE LA MÉTHODE _noms() (elle est maintenant dans le provider)

  void _message(BuildContext context, String texte) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texte)));
  }

  Future<void> _ajouter(BuildContext context) async {
    // On lit les noms depuis le provider (read car on est dans une action)
    final noms = context.read<ZonesProvider>().noms();

    final nouvelle = await Navigator.push<Zone>(
      context,
      MaterialPageRoute(
        builder: (_) => ZoneFormPage(nomsExistants: noms),
      ),
    );
    if (nouvelle == null || !context.mounted) return;

    // On ajoute via le provider
    context.read<ZonesProvider>().ajouter(nouvelle);
    _message(context, 'Zone ajoutée');
  }

  Future<void> _ouvrirDetail(BuildContext context, Zone zone) async {
    // On lit les noms (en excluant la zone en cours) depuis le provider
    final noms = context.read<ZonesProvider>().noms(sauf: zone);

    final modifiee = await Navigator.push<Zone>(
      context,
      MaterialPageRoute(
        builder: (_) => ZoneDetailPage(
          zone: zone,
          nomsAutres: noms,
        ),
      ),
    );
    if (modifiee == null || !context.mounted) return;

    // On remplace via le provider
    context.read<ZonesProvider>().remplacer(zone, modifiee);
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

    // On supprime via le provider
    context.read<ZonesProvider>().supprimer(zone);
    _message(context, 'Zone supprimée');
  }

  Widget _carte(BuildContext context, Zone zone) {
    // On récupère le provider une seule fois pour la carte
    final provider = context.read<ZonesProvider>();

    return ZoneCard(
      zone: zone,
      onAugmenter: () => provider.modifierHumidite(zone, 5),
      onDiminuer: () => provider.modifierHumidite(zone, -5),
      onTap: () => _ouvrirDetail(context, zone),
      onLongPress: () => _confirmerSuppression(context, zone),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 6. ON ÉCOUTE LE PROVIDER ICI (watch)
    // Toute la page se met à jour si les zones changent
    final zones = context.watch<ZonesProvider>().zones;

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