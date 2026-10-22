import 'package:agrismart/models/zone.dart';
List<Zone> jeuDeDonnees(){
  return[
    Zone('Parcelle Nord', 'Tomates', 28, 35),
    Zone('Parcelle Sud', 'Oliviers', 42, 30),
    Zone('Serre 1', 'Fraise', 55, 50,vanneOuverte: true),
    Zone('Parcelle Est', 'Blé', 20, 35),
    Zone('Parcelle Ouest', 'Orge', 38, 35),
    Zone('Serre 2', 'Poivrons', 60, 55),
    Zone('Verger', 'Pommiers', 33, 30),
    Zone('Parcelle Centre', 'Luzerne', 25, 40),
    Zone('Serre 3', 'Concombres', 70, 60),
    Zone('Palmeraie', 'Dattiers', 45, 40),
  ];

}