import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/screens/profil_page.dart';
import 'package:agrismart/screens/statistiques_page.dart';
import 'package:agrismart/screens/zones_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _onglet = 0;

  @override
  Widget build(BuildContext context) {
    // select : on ne reconstruit la barre que si CE nombre change
    final aIrriguer = context.select<ZonesProvider, int>(
          (p) => p.nombreAirriger,
    );

    return Scaffold(
      body: IndexedStack(
        index: _onglet,
        children: const [
          ZonesPage(),
          StatistiquesPage(),
          ProfilPage(),
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