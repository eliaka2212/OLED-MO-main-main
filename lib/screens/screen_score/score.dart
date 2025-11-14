

import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  const Score({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes scores')),
      body: const Center(
        child: Text('Liste des scores ici'),
        
      ),
    );
  }
}
