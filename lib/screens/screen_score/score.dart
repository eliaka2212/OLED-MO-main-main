

import 'package:flutter/material.dart';
import 'package:mobil_cds49/services/api/gestionScore/score_api.dart';

class Score extends StatelessWidget {
  const Score({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes scores')),
      body: FutureBuilder<List<dynamic>>(
        future: ScoreApi.getScores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun score trouvé.'));
          }

          final scores = snapshot.data!;
          
          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final item = scores[index];
              final score = item['score'] ?? 0;
              final nbQuestions = item['nbquestions'] ?? 0;
              // Tentative de récupération de la date sous différents formats possibles
              final dateStr = item['date'] ?? item['created_at'] ?? item['createdAt'] ?? '';
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.emoji_events, color: Colors.amber),
                  title: Text(
                    'Score : $score / $nbQuestions',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: dateStr.toString().isNotEmpty 
                    ? Text(
                        dateStr.toString().split('T')[0], // Affiche seulement la date YYYY-MM-DD si format ISO
                        style: const TextStyle(color: Colors.grey),
                      ) 
                    : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
