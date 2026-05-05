

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
              final itemMap = item is Map<String, dynamic> ? item : <String, dynamic>{};
              final score = itemMap['score']
                  ?? itemMap['scoreRealise']
                  ?? itemMap['score_realise']
                  ?? itemMap['score_total']
                  ?? itemMap['scoreTotal']
                  ?? 0;
              final nbQuestions = itemMap['nbquestions']
                  ?? itemMap['nbQuestions']
                  ?? itemMap['nb_questions']
                  ?? itemMap['total_questions']
                  ?? itemMap['nbQuestionsTotal']
                  ?? 0;
              final dateStr = itemMap['dateresultat']
                  ?? itemMap['dateresultat']
                  ?? itemMap['dateresult']
                  ?? itemMap['date']
                  ?? itemMap['created_at']
                  ?? itemMap['createdAt']
                  ?? itemMap['date_created']
                  ?? itemMap['timestamp']
                  ?? '';
              final categorie = itemMap['categorie'] ?? itemMap['category'];
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.emoji_events, color: Colors.amber),
                  title: Text(
                    'Score : $score / $nbQuestions',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: categorie != null ? Text('Catégorie : $categorie') : null,
                  trailing: dateStr.toString().isNotEmpty 
                    ? Text(
                        dateStr.toString().split(' ')[0],
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
