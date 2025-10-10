import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobil_cds49/screens/screen_qcm/affichageqcm.dart';

// Écran permettant de sélectionner le nombre de questions et la catégorie pour un QCM
class CodeQCM extends StatefulWidget {
  final void Function(Widget)? onNavigate;
  const CodeQCM({super.key, this.onNavigate});

  @override
  State<CodeQCM> createState() => _CodeQCMState();
}

class _CodeQCMState extends State<CodeQCM> {
  int selectedNumber = 40;
  String selectedCategory = 'random';

  final dropdownValues = [0, 10, 20, 30, 40];
  late final List<DropdownMenuItem<int>> dropdownItems;

  @override
  void initState() {
    super.initState();
    dropdownItems = dropdownValues
        .map((value) =>
            DropdownMenuItem<int>(value: value, child: Text('$value')))
        .toList();
  }

  // Détermine la catégorie choisie
  String selectCategorie() => selectedCategory;

  // Méthode pour construire chaque carte de catégorie
  Widget _buildCategoryCard(
      String title, IconData icon, String categoryKey) {
    bool isSelected = selectedCategory == categoryKey;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = categoryKey;
        });
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[100] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.orange, width: 2)
              : Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.orange),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chevrollier Driving School', style: TextStyle(fontSize: 22)),

            // Carte pour sélectionner le nombre de questions
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Nombre de questions',
                        style: TextStyle(fontSize: 18)),
                    DropdownButton<int>(
                      value: selectedNumber,
                      items: dropdownItems,
                      onChanged: (value) {
                        setState(() {
                          selectedNumber = value!;
                        });
                      },
                      isExpanded: true,
                    ),
                  ],
                ),
              ),
            ),

            // Espacement
            SizedBox(height: 32),

            // Liste horizontale des catégories
            SizedBox(
              height: 135,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryCard(
                      'Aléatoire', FontAwesomeIcons.shuffle, 'random'),
                  _buildCategoryCard(
                      'Signalisation', FontAwesomeIcons.road, 'signalisation'),
                  _buildCategoryCard(
                      'Théorique', FontAwesomeIcons.book, 'theorique'),
                  _buildCategoryCard(
                      'Priorités', FontAwesomeIcons.trafficLight, 'priorites'),
                  _buildCategoryCard(
                      'Sécurité', FontAwesomeIcons.shield, 'securite'),
                  _buildCategoryCard(
                      'Vitesse', FontAwesomeIcons.tachographDigital, 'vitesse'),
                  _buildCategoryCard(
                      'Stationnement', FontAwesomeIcons.car, 'stationnement'),
                  _buildCategoryCard(
                      'Conditions météo', FontAwesomeIcons.cloudRain, 'meteo'),
                  _buildCategoryCard(
                      'Règles diverses', FontAwesomeIcons.gavel, 'diverses'),
                  _buildCategoryCard(
                      'Véhicule', FontAwesomeIcons.carRear, 'vehicule'),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Bouton Valider
            ElevatedButton(
              onPressed: () {
                widget.onNavigate?.call(
                  AffichageQCM(
                    key: UniqueKey(),
                    nbQuestions: selectedNumber,
                    categorieQuestion: selectCategorie(),
                    onNavigate: widget.onNavigate,
                  ),
                );
              },
              child: Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}
