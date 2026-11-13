import 'dart:async';
import 'package:agrismart/models/utilisateur.dart';
import 'package:agrismart/services/auth_service.dart';

// Variante sans Firebase : les comptes sont gardes en memoire
// (ils disparaissent a la fermeture de l'application).
class AuthLocaleService implements AuthService {
  final Map<String, String> _comptes = {'demo@agrismart.tn': '123456'};
  final StreamController<Utilisateur?> _controller =
  StreamController<Utilisateur?>.broadcast();
  Utilisateur? _courant;

  @override
  Stream<Utilisateur?> get utilisateur async* {
    yield _courant;
    yield* _controller.stream;
  }

  void _definir(Utilisateur? u) {
    _courant = u;
    _controller.add(u);
  }

  @override
  Future<void> connexion(String email, String motDePasse) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final cle = email.trim().toLowerCase();
    if (_comptes[cle] != motDePasse) {
      throw const AuthException('Email ou mot de passe incorrect');
    }
    _definir(Utilisateur(uid: cle, email: cle));
  }

  @override
  Future<void> inscription(String email, String motDePasse) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final cle = email.trim().toLowerCase();
    if (_comptes.containsKey(cle)) {
      throw const AuthException('Un compte existe déjà avec cet email');
    }
    _comptes[cle] = motDePasse;
    _definir(Utilisateur(uid: cle, email: cle));
  }

  @override
  Future<void> reinitialiserMotDePasse(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<void> deconnexion() async {
    _definir(null);
  }
}
