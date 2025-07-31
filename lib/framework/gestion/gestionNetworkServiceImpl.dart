import 'dart:convert';

import 'package:odc_mobile_template/business/models/article/event.dart';

import '../../business/models/article/article.dart';
import '../../business/models/article/category.dart';
import '../../business/services/gestion/gestionNetworkService.dart';
import '../../utils/http/HttpUtils.dart';

class GestionNetworkServiceImpl implements GestionNetworkService {
  String baseUrl;
  HttpUtils httpUtils;

  GestionNetworkServiceImpl({required this.baseUrl, required this.httpUtils});

  @override
  Future<Article> recupererArticle(int id) {
    // TODO: implement recupererArticle
    throw UnimplementedError();
  }

  @override
  Future<List<Article>> recupererArticles() async {
    var url = '$baseUrl/articles';
    var response = await httpUtils.getData(url);
    var listData = jsonDecode(response);
    var listArticles =
        listData.map<Article>((e) => Article.fromJson(e)).toList();
    return listArticles;
  }

  @override
  Future<Event> recuperEventById(int? id, String token) async {
    final String url = '$baseUrl/events/auth/$id';

    try {
      final response = await httpUtils.getData(url,headers:{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      } );

      // Décodage du JSON si nécessaire
      final jsonResponse = response is String ? jsonDecode(response) : response;

      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        final eventData = jsonResponse['data'];
        print("Événement récupéré : $eventData");

        // Utilisation du constructeur fromJson de Event
        return Event.fromJson(eventData);
      } else {
        throw Exception("Réponse inattendue lors de la récupération de l’événement.");
      }
    } catch (e) {
      print("Erreur lors de la récupération de l’événement par ID : $e");
      throw Exception("Échec de récupération de l’événement.");
    }
  }

  @override
  Future<List<Event>> recupererEvents() async {
    var url = '$baseUrl/events';
    var response = await httpUtils.getData(url);

    // Si response est un JSON encodé (String), décode-le d’abord
    final jsonResponse = response is String ? jsonDecode(response) : response;

    if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
      List<dynamic> eventData = jsonResponse['data'];
      print("les événements venant du backend : $eventData");
      return eventData.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception("Format de réponse inattendu lors de la récupération des événements");
    }
  }

  @override
  Future<List<Event>> recupererDerniersEvents(int count) async {
    final String url = '$baseUrl/events?latest=true&count=$count';

    try {
      final response = await httpUtils.getData(url);

      final jsonResponse = response is String ? jsonDecode(response) : response;

      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        List<dynamic> eventData = jsonResponse['data'];
        print("Derniers $count événements récupérés : $eventData");
        return eventData.map((event) => Event.fromJson(event)).toList();
      } else {
        throw Exception("Réponse inattendue lors de la récupération des événements.");
      }
    } catch (e) {
      print("Erreur lors de la récupération des derniers événements : $e");
      throw Exception("Échec de récupération des derniers événements.");
    }
  }

  @override
  Future<int> favorite(int eventId, String token) async {
    final url = '$baseUrl/events/$eventId/favorite';
    final jsons = {'event_id': eventId};

    try {
      final response = await httpUtils.postData(
        url,
        body: jsons,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // On suppose que `response` est une String JSON
      final decodedJson = jsonDecode(response);

      print("Réponse du serveur : $decodedJson");

      // Si tu veux accéder au message :
     // final message = decodedJson['data']['message'];
      final message = decodedJson['data']['etat'];
      print("etat: $message");
      return message;

    } catch (e) {
      print("Erreur lors de l'appel à favorite : $e");
      throw Exception("Erreur lors de l'appel à favorite.");
    }
  }




  @override
  Future<List<Category>> getCategories() async {
    final url = '$baseUrl/categories';

    try {
      final responseBody = await httpUtils.getData(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final decodedJson = jsonDecode(responseBody);

      if (decodedJson is Map<String, dynamic> && decodedJson.containsKey('data')) {
        final data = decodedJson['data'];
        if (data is List) {
          return data.map((item) => Category.fromJson(item)).toList();
        } else {
          throw Exception('Le champ "data" n\'est pas une liste');
        }
      } else {
        throw Exception('Réponse inattendue du serveur');
      }
    } catch (e) {
      print('Erreur lors du chargement des catégories : $e');
      throw Exception('Impossible de charger les catégories');
    }
  }


  @override
  Future<void> subscribe(int eventId, String token) async {
    final url = '$baseUrl/events/$eventId/subscribe';
    final jsons = {'event_id': eventId};

    try {
      final response = await httpUtils.postData(
        url,
        body: jsons,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // On suppose que `response` est une String JSON
      final decodedJson = jsonDecode(response);

      print("Réponse du serveur : $decodedJson");

      // Si tu veux accéder au message :
      final message = decodedJson['data']['message'];
      print("Message: $message");

    } catch (e) {
      print("Erreur lors de l'appel à subscribe : $e");
      throw Exception("Erreur lors de l'appel à subscribe.");
    }
  }

}



