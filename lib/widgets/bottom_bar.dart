import 'package:flutter/material.dart';
import 'package:mobil_cds49/services/gestion_token/token.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onDestinationSelected;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });
  // Empeche l'utilisateur de naviguer vers le QCM s'il n'est pas connecté
  Future<void> _verifQCM(BuildContext context, int index) async {
    if (index == 1) {
      final autorise = await GestionToken.isLogged();
      if (!autorise && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez vous connecter pour accéder au QCM')),
        );
        return;
      }
    }
    onDestinationSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    // Construction de la barre de navigation 
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => _verifQCM(context, index),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Acceuil',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.question_mark),
          icon: Icon(Icons.question_mark_outlined),
          label: 'QCM',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings_outlined),
          label: 'Paramètres',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.contacts),
          icon: Icon(Icons.contacts_outlined),
          label: 'Nous contacter',
        ),
      ],
    );
  }
}