import 'package:odc_mobile_template/business/models/article/category.dart';
import 'package:odc_mobile_template/business/models/article/event.dart';

import '../../models/article/article.dart';

abstract class GestionNetworkService {
  Future<List<Article>> recupererArticles();
  Future<Article> recupererArticle(int id);
  Future<Event> recuperEventById(int? id);
  Future<List<Event>> recupererEvents();
  Future<List<Event>> recupererDerniersEvents(int count);
  Future<void> favorite(int eventId, String token);
  Future<List<Category>> getCategories();
  Future<void> subscribe(int eventId, String token);
 }
  