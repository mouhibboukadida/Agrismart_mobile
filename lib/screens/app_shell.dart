import 'package:flutter/material.dart';
import 'package:agrismart/data/jeu_de_donnees.dart';
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/screens/profil_page.dart';
import 'package:agrismart/screens/statistiques_page.dart';
import 'package:agrismart/screens/zones_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final List<Zone> _zones = jeuDeDonnees();
  int _onglet = 0;

  void _modifierHumidite(Zone zone, double delta) {
    setState(() {
      zone.humidite = (zone.humidite + delta).clamp(0, 100).toDouble();
    });
  }

  void _ajouter(Zone zone) {
    setState(() {
      _zones.add(zone);
    });
  }

  void _remplacer(Zone ancienne, Zone nouvelle) {
    setState(() {
      final index = _zones.indexOf(ancienne);
      if (index != -1) _zones[index] = nouvelle;
    });
  }

  void _supprimer(Zone zone) {
    setState(() {
      _zones.remove(zone);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. On calcule le nombre de zones à irriguer
    final int aIrriguer = _zones.where((z) => z.besoinIrrigation).length;

    return Scaffold(
      body: IndexedStack(
        index: _onglet,
        children: [
          ZonesPage(
            zones: _zones,
            onModifierHumidite: _modifierHumidite,
            onAjouter: _ajouter,
            onRemplacer: _remplacer,
            onSupprimer: _supprimer,
          ),
          StatistiquesPage(zones: _zones),
          ProfilPage(nombreZones: _zones.length),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (index) {
          setState(() {
            _onglet = index;
          });
        },
        destinations: [
          NavigationDestination(
            // 2 et 3. On entoure l'icône avec un Badge
            icon: Badge(
              label: Text('$aIrriguer'),
              isLabelVisible: aIrriguer > 0,
              child: const Icon(Icons.grass_outlined),
            ),
            selectedIcon: Badge(
              label: Text('$aIrriguer'),
              isLabelVisible: aIrriguer > 0,
              child: const Icon(Icons.grass),
            ),
            label: 'Zones',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}