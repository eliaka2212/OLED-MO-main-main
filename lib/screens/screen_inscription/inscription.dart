import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();

  String nom = '';
  String prenom = '';
  String email = '';
  String motDePasse = '';
  String confirmationMotDePasse = '';
  String numeroTelephone = '';
  DateTime? dateDeNaissance;

  bool isLoading = false;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> Inscription() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      try {
        final url = Uri.parse(
          'http://192.168.109.10/api/register',
        ); // <-- Remplace par ton URL API

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nom': nom,
            'prenom': prenom,
            'email': email,
            'numero': numeroTelephone,
            'password': motDePasse,
            'confirm_password': confirmationMotDePasse,
            'date_naissance': dateDeNaissance != null
                ? "${dateDeNaissance!.year}-${dateDeNaissance!.month.toString().padLeft(2, '0')}-${dateDeNaissance!.day.toString().padLeft(2, '0')}"
                : null,
          }),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Inscription réussie')),
          );

          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Erreur lors de l\'inscription'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur réseau : $e')));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Champ Nom
                TextFormField(
                  decoration: InputDecoration(labelText: "Nom"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrez votre nom";
                    } else if (!RegExp(
                      r"^[a-zA-ZÀ-ÿ\s\-']+$",
                    ).hasMatch(value)) {
                      return "Le Nom ne peut contenir que des lettres";
                    }
                    return null;
                  },
                  onSaved: (value) => nom = value!,
                ),
                SizedBox(height: 16),

                // Champ Prénom
                TextFormField(
                  decoration: InputDecoration(labelText: "Prénom"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrez votre prénom";
                    } else if (!RegExp(
                      r"^[a-zA-ZÀ-ÿ\s\-']+$",
                    ).hasMatch(value)) {
                      return "Le Prénom ne peut contenir que des lettres";
                    }
                    return null;
                  },
                  onSaved: (value) => prenom = value!,
                ),
                SizedBox(height: 16),

                // Champ Email
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrez votre adresse mail ";
                    } else if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value)) {
                      return "veuillez saisir une adresse mail valide";
                    }
                    return null;
                  },
                  onSaved: (value) => email = value!,
                ),
                SizedBox(height: 16),

                // Champ Numéro de téléphone
                TextFormField(
                  decoration: InputDecoration(labelText: "Numéro de téléphone"),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrez votre numéro de téléphone";
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return "Numéro invalide (10 chiffres requis)";
                    }
                    return null;
                  },
                  onSaved: (value) => numeroTelephone = value!,
                ),
                SizedBox(height: 16),

                // Champ Date de naissance
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Date de naissance",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      dateDeNaissance = picked;
                      _dateController.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                    }
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? "Choisissez votre date de naissance"
                      : null,
                ),
                SizedBox(height: 16),

                // Champ Mot de passe
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Mot de passe"),
                  obscureText: true,
                  validator: (value) => value == null || value.length < 6
                      ? "Minimum 6 caractères"
                      : null,
                  onSaved: (value) => motDePasse = value!,
                ),
                SizedBox(height: 16),

                // Confirmation mot de passe
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Confirmez le mot de passe",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirmez votre mot de passe";
                    } else if (value != _passwordController.text) {
                      return "Les mots de passe ne correspondent pas";
                    }
                    return null;
                  },
                  onSaved: (value) => confirmationMotDePasse = value!,
                ),
                SizedBox(height: 32),

                // Bouton S'inscrire
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: Inscription,
                        child: Text("S'inscrire"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
