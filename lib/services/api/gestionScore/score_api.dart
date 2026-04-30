import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobil_cds49/services/api/config.dart';
import 'package:mobil_cds49/services/gestion_token/token.dart';

class ScoreApi {
  static Future<int> envoyerScore(int score, int nbQuestions) async {  
    final token = await GestionToken.getToken(); 
    if (token == null || token.isEmpty) return 401;
    
    // Vérification : on s'assure qu'il n'y a pas de double slash //api//
    String baseUrl = AppConfig.apiBaseUrl.endsWith('/') 
        ? AppConfig.apiBaseUrl.substring(0, AppConfig.apiBaseUrl.length - 1) 
        : AppConfig.apiBaseUrl;

    final url = Uri.parse('$baseUrl/api/fin-test');  
    
    try {
      print("Envoi JSON Strict vers $url");
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', 
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'score': score, 
          'nbquestions': nbQuestions,
        }),
      );    

      print("Code: ${response.statusCode} | Body: ${response.body}");
      return response.statusCode; 
            
    } catch (e) {
      print("Erreur connection API : $e"); 
      return 500; 
    }  
  }

  static Future<List<dynamic>> getScores() async {
    final token = await GestionToken.getToken();
    if (token == null || token.isEmpty) return [];

    String baseUrl = AppConfig.apiBaseUrl.endsWith('/')
        ? AppConfig.apiBaseUrl.substring(0, AppConfig.apiBaseUrl.length - 1)
        : AppConfig.apiBaseUrl;

    final url = Uri.parse('$baseUrl/api/mes-scores');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print("Erreur récupération scores : ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Erreur connection API (getScores) : $e");
      return [];
    }
  }
}