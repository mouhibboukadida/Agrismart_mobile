import 'package:flutter/material.dart';
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/theme/app_theme.dart';

class ZoneCard extends StatelessWidget {
  final Zone zone;
  final VoidCallback onAugmenter;
  final VoidCallback onDiminuer;
  final VoidCallback? onTap;

  const ZoneCard({
    super.key,
    required this.zone,
    required this.onAugmenter,
    required this.onDiminuer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final couleur = zone.besoinIrrigation ? AppTheme.echec : AppTheme.succes;
    final initiales = zone.culture.length >= 4
        ? zone.culture.substring(0, 4)
        : zone.culture;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // TODO 1 : CircleAvatar avec les 4 premières lettres de la culture
            CircleAvatar(
              backgroundColor: couleur.withOpacity(0.15),
              child: Text(
                initiales,
                style: TextStyle(color: couleur, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TODO 2 : nom de la zone, en gras
                  Text(
                    zone.nom,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // TODO 3 : statut coloré
                  Text(
                    zone.besoinIrrigation ? "Besoin d'irrigation" : "Sol correct",
                    style: TextStyle(color: couleur),
                  ),
                  const SizedBox(height: 6),
                  // TODO 4 : barre de progression
                  LinearProgressIndicator(
                    value: zone.humidite / 100,
                    color: couleur,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // TODO 5 : humidité + Row de deux IconButton
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${zone.humidite.toStringAsFixed(0)} %'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onDiminuer,
                      icon: const Icon(Icons.remove),
                    ),
                    IconButton(
                      onPressed: onAugmenter,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    )
    );
  }
}