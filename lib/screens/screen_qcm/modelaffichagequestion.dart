import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobil_cds49/models/questionavecreponse.dart';
import 'package:mobil_cds49/models/reponse.dart';
import 'package:mobil_cds49/services/api/config.dart';

class QuestionWidget extends StatefulWidget {
  final QuestionAvecReponses questionData;
  final VoidCallback onNext;
  final Function(List<Reponse>) onNextWithReponses;

  const QuestionWidget({
    super.key,
    required this.questionData,
    required this.onNext,
    required this.onNextWithReponses,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late List<bool> _selections;
  Timer? _timer;
  int _timeLeft = 20;

  @override
  void initState() {
    super.initState();
    _selections = List.generate(
      widget.questionData.reponses.length,
      (_) => false,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        timer.cancel();
        final reponsesCochees = getReponsesSelect();
        widget.onNextWithReponses(reponsesCochees);
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  List<Reponse> getReponsesSelect() {
    final reponses = widget.questionData.reponses;
    return List.generate(reponses.length, (index) {
      if (_selections[index]) return reponses[index];
      return null;
    }).whereType<Reponse>().toList();
  }

  @override
  void didUpdateWidget(covariant QuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionData != widget.questionData) {
      _selections = List.generate(
        widget.questionData.reponses.length,
        (_) => false,
      );
      _startTimer(); // Redémarre le timer pour la nouvelle question
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Libère les ressources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questionData.question;
    final reponses = widget.questionData.reponses;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            question.libelle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Image.network(
            'https://${AppConfig.apiBaseUrl}/public/images/${question.image}',
            height: 150,
            errorBuilder: (context, error, stackTrace) {
              return const Text("Image non disponible");
            },
          ),
          const SizedBox(height: 24),

          // ✅ Timer affiché ici
          Text(
            "Temps restant : $_timeLeft secondes",
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: reponses.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(reponses[index].libelle),
                  value: _selections[index],
                  onChanged: (bool? selected) {
                    setState(() {
                      _selections[index] = selected ?? false;
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _timer?.cancel(); // Arrête le timer si l'utilisateur répond
              final reponsesCochees = getReponsesSelect();
              widget.onNextWithReponses(reponsesCochees);
            },
            child: const Text("Question suivante"),
          ),
        ],
      ),
    );
  }
}
