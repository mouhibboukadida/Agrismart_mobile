import 'package:flutter/material.dart';
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/theme/app_theme.dart';

class ZoneCard extends StatelessWidget {
  final Zone zone;
  final VoidCallback onAugmenter;
  final VoidCallback onDiminuer;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress; // Ajouté pour la suppression

  const ZoneCard({
    super.key,
    required this.zone,
    required this.onAugmenter,
    required this.onDiminuer,
    this.onTap,
    this.onLongPress,
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
        onLongPress: onLongPress, // NOUVEAU : Lié à l'InkWell
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: couleur.withValues(alpha: 0.15),
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
                    Text(
                      zone.nom,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      zone.besoinIrrigation ? "Besoin d'irrigation" : "Sol correct",
                      style: TextStyle(color: couleur),
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: zone.humidite / 100,
                      color: couleur,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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
      ),
    );
  }
}