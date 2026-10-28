import 'package:flutter/material.dart';
import 'package:agrismart/models/zone.dart';

class ZoneForm extends StatefulWidget {
  final Zone? zone;
  final List<String> nomsExistants;
  final void Function(Zone) onEnregistrer;

  const ZoneForm({
    super.key,
    this.zone,
    required this.onEnregistrer,
    required this.nomsExistants,
  });

  @override
  State<ZoneForm> createState() => _ZoneFormState();
}

class _ZoneFormState extends State<ZoneForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _cultureCtrl = TextEditingController();
  final _humiditeCtrl = TextEditingController();
  final _seuilCtrl = TextEditingController();

  bool get _modeEdition => widget.zone != null;

  @override
  void initState() {
    super.initState();
    final zone = widget.zone;
    if (zone != null) {
      _nomCtrl.text = zone.nom;
      _cultureCtrl.text = zone.culture;
      _seuilCtrl.text = _formater(zone.seuil);
    }
  }

  String? _validatorNom(String? valeur) {
    final erreurTexte = _validatorTexte(valeur);
    if (erreurTexte != null) return erreurTexte;

    final nomSaisi = valeur!.trim().toLowerCase();

    final existeDeja = widget.nomsExistants
        .any((nom) => nom.toLowerCase() == nomSaisi);

    if (existeDeja) {
      return 'Ce nom existe déjà';
    }
    return null;
  }

  String _formater(double n) {
    return n % 1 == 0 ? n.toStringAsFixed(0) : n.toString();
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _cultureCtrl.dispose();
    _humiditeCtrl.dispose();
    _seuilCtrl.dispose();
    super.dispose();
  }

  double? _lireNombre(String? texte) {
    return double.tryParse((texte ?? '').trim().replaceAll(',', '.'));
  }

  String? _validatorTexte(String? valeur) {
    if (valeur == null || valeur.trim().length < 2) {
      return 'Ce champ est obligatoire (min. 2 caractères)';
    }
    return null;
  }

  String? _validatorPourcentage(String? valeur) {
    final nombre = _lireNombre(valeur);
    if (nombre == null) {
      return 'Veuillez saisir un nombre valide';
    }
    if (nombre < 0 || nombre > 100) {
      return 'Le nombre doit être entre 0 et 100';
    }
    return null;
  }

  void _soumettre() {
    if (_formKey.currentState!.validate()) {
      final humidite = _modeEdition
          ? widget.zone!.humidite
          : (_lireNombre(_humiditeCtrl.text) ?? 0.0);

      final vanne = _modeEdition ? widget.zone!.vanneOuverte : false;

      final nouvelleZone = Zone(
        _nomCtrl.text.trim(),
        _cultureCtrl.text.trim(),
        humidite,
        _lireNombre(_seuilCtrl.text) ?? 0.0,
        vanneOuverte: vanne,
      );

      widget.onEnregistrer(nouvelleZone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _modeEdition ? 'Modifier la zone' : 'Nouvelle zone',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // CHAMP NOM
            TextFormField(
              controller: _nomCtrl,
              decoration: const InputDecoration(
                labelText: 'Nom de la zone',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              // CORRECTION ICI : Utiliser _validatorNom au lieu de _validatorTexte
              validator: _validatorNom,
            ),

            const SizedBox(height: 12),

            // CHAMP CULTURE
            TextFormField(
              controller: _cultureCtrl,
              decoration: const InputDecoration(
                labelText: 'Culture',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              validator: _validatorTexte,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_modeEdition)
                  Expanded(
                    child: TextFormField(
                      controller: _humiditeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Humidité (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: _validatorPourcentage,
                    ),
                  ),
                if (!_modeEdition) const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _seuilCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Seuil (%)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: _validatorPourcentage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _soumettre,
              child: Text(_modeEdition ? 'Enregistrer' : 'Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}