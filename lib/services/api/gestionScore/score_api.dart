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
    if (token == null || token.isEmpty) {
      throw Exception('Token introuvable. Veuillez vous reconnecter.');
    }

    String baseUrl = AppConfig.apiBaseUrl.endsWith('/')
        ? AppConfig.apiBaseUrl.substring(0, AppConfig.apiBaseUrl.length - 1)
        : AppConfig.apiBaseUrl;

    final url = Uri.parse('$baseUrl/api/scores');
    print('Récupération des scores depuis $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Réponse scores ${response.statusCode}: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Erreur récupération scores ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is List<dynamic>) {
        return decoded;
      }

      if (decoded is Map<String, dynamic>) {
        if (decoded['scores'] is List<dynamic>) {
          return decoded['scores'] as List<dynamic>;
        }
        if (decoded['data'] is List<dynamic>) {
          return decoded['data'] as List<dynamic>;
        }
        if (decoded['data'] is Map<String, dynamic>) {
          final data = decoded['data'] as Map<String, dynamic>;
          if (data['scores'] is List<dynamic>) {
            return data['scores'] as List<dynamic>;
          }
          if (data['items'] is List<dynamic>) {
            return data['items'] as List<dynamic>;
          }
        }
        if (decoded['items'] is List<dynamic>) {
          return decoded['items'] as List<dynamic>;
        }
        if (decoded['history'] is List<dynamic>) {
          return decoded['history'] as List<dynamic>;
        }
        if (decoded.containsKey('score')) {
          return [decoded];
        }
      }

      throw Exception('Format de réponse inattendu pour les scores');
    } catch (e) {
      print('Erreur connection API (getScores) : $e');
      rethrow;
    }
  }
}