import 'dart:convert';

import 'package:odc_mobile_template/business/models/article/event.dart';

import '../../business/models/article/article.dart';
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
  Future<Event> recuperEventById(int id) {
    // TODO: implement recuperEventById
    throw UnimplementedError();
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


}



