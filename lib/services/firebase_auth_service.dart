import 'package:firebase_auth/firebase_auth.dart';
import 'package:agrismart/models/utilisateur.dart';
import 'package:agrismart/services/auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<Utilisateur?> get utilisateur {
    return _auth.authStateChanges().map((u) {
      if (u == null) return null;
      return Utilisateur(uid: u.uid, email: u.email ?? '');
    });
  }

  @override
  Future<void> connexion(String email, String motDePasse) {
    return _executer(() => _auth.signInWithEmailAndPassword(
        email: email.trim(), password: motDePasse));
  }

  @override
  Future<void> inscription(String email, String motDePasse) {
    return _executer(() => _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: motDePasse));
  }

  @override
  Future<void> reinitialiserMotDePasse(String email) {
    return _executer(() => _auth.sendPasswordResetEmail(email: email.trim()));
  }

  @override
  Future<void> deconnexion() => _auth.signOut();

  // Execute une operation Firebase et traduit les erreurs en francais
  Future<void> _executer(Future<void> Function() operation) async {
    try {
      await operation();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_traduire(e.code));
    } catch (_) {
      throw const AuthException('Une erreur est survenue');
    }
  }

  String _traduire(String code) {
    switch (code) {
      case 'invalid-email':
        return "L'adresse email n'est pas valide";
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect';
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet email';
      case 'weak-password':
        return 'Mot de passe trop faible (6 caractères minimum)';
      case 'network-request-failed':
        return 'Pas de connexion Internet';
      case 'too-many-requests':
        return 'Trop de tentatives, réessayez plus tard';
      default:
        return "Erreur d'authentification ($code)";
    }
  }
}
