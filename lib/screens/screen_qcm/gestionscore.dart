import 'package:flutter/material.dart';
import 'package:mobil_cds49/main.dart';
import 'package:mobil_cds49/services/api/gestionScore/score_api.dart';
import 'package:mobil_cds49/screens/screen_score/score.dart';

class GestionScore extends StatefulWidget {
  final int nbQuestionsTotal;
  final int scoreRealise;

  const GestionScore({
    super.key, 
    required this.nbQuestionsTotal, 
    required this.scoreRealise
  });

  @override
  State<GestionScore> createState() => _GestionScoreState();
}

class _GestionScoreState extends State<GestionScore> {

  void _retourAccueil() {
    // 1. Envoi "Fire & Forget" : on n'attend plus la réponse (await) pour naviguer
    ScoreApi.envoyerScore(
      widget.scoreRealise,
      widget.nbQuestionsTotal,
    ).then((code) {
       print("Envoi terminé en arrière-plan : $code");
    });

    // 2. Navigation forcée et immédiate vers l'accueil
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => MyHomePage(title: 'CDS 49')),
      (route) => false,
    );
  }

  void _voirScoresPrecedents() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const Score()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Résultat du QCM',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              '${widget.scoreRealise} / ${widget.nbQuestionsTotal}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  onPressed: _voirScoresPrecedents,
                  child: const Text(
                    'Voir mes scores précédents',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  onPressed: _retourAccueil,
                  child: const Text(
                    'Retour à l\'accueil',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}