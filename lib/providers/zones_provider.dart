import 'package:flutter/foundation.dart';
import 'package:agrismart/data/jeu_de_donnees.dart';
import 'package:agrismart/models/zone.dart';

class ZonesProvider extends ChangeNotifier {
  final List<Zone> _zones = jeuDeDonnees();

  // Copie en lecture seule
  List<Zone> get zones => List.unmodifiable(_zones);

  int get nombre => _zones.length;
  int get nombreAirriger => _zones.where((z) => z.besoinIrrigation).length;

  List<String> noms({Zone? sauf}) {
    return _zones.where((z) => z != sauf).map((z) => z.nom).toList();
  }

  // TODO 1
  void modifierHumidite(Zone zone, double delta) {
    zone.humidite = (zone.humidite + delta).clamp(0, 100).toDouble();
    notifyListeners();
  }

  // TODO 2
  void ajouter(Zone zone) {
    _zones.add(zone);
    notifyListeners();
  }

  // TODO 3
  void remplacer(Zone ancienne, Zone nouvelle) {
    final index = _zones.indexOf(ancienne);
    if (index != -1) {
      _zones[index] = nouvelle;
      notifyListeners();
    }
  }

  // TODO 4
  void supprimer(Zone zone) {
    _zones.remove(zone);
    notifyListeners();
  }
}