import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:agrismart/models/utilisateur.dart';
import 'package:agrismart/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;
  late final StreamSubscription<Utilisateur?> _abonnement;

  Utilisateur? _utilisateur;
  bool _initialise = false; // vrai apres le premier evenement du flux
  bool _occupe = false; // une operation est en cours
  String? _erreur;

  AuthProvider(this._service) {
    _abonnement = _service.utilisateur.listen((u) {
      _utilisateur = u;
      _initialise = true;
      notifyListeners();
    });
  }

  Utilisateur? get utilisateur => _utilisateur;
  bool get initialise => _initialise;
  bool get occupe => _occupe;
  String? get erreur => _erreur;
  bool get connecte => _utilisateur != null;

  // Les trois operations renvoient true en cas de succes.
  Future<bool> connexion(String email, String motDePasse) {
    return _executer(() => _service.connexion(email, motDePasse));
  }

  Future<bool> inscription(String email, String motDePasse) {
    return _executer(() => _service.inscription(email, motDePasse));
  }

  Future<bool> reinitialiserMotDePasse(String email) {
    return _executer(() => _service.reinitialiserMotDePasse(email));
  }

  Future<void> deconnexion() => _service.deconnexion();

  void effacerErreur() {
    if (_erreur == null) return;
    _erreur = null;
    notifyListeners();
  }

  Future<bool> _executer(Future<void> Function() operation) async {
    _occupe = true;
    _erreur = null;
    notifyListeners();
    var succes = false;
    try {
      await operation();
      succes = true;
    } on AuthException catch (e) {
      _erreur = e.message;
    } catch (_) {
      _erreur = 'Une erreur est survenue';
    }
    _occupe = false;
    notifyListeners();
    return succes;
  }

  @override
  void dispose() {
    _abonnement.cancel(); // on se desabonne du flux
    super.dispose();
  }
}
