import 'package:clean_catalogue_app/models/catalogue_scores_model.dart';

class Catalogue {
  final String catalogueID;
  final String name;
  final DateTime date;
  final List<ImageObject> images;
  final CatalogueScores result;
  String? description;

  Catalogue({
    required this.name,
    required this.date,
    required this.catalogueID,
    required this.images,
    required this.result,
    this.description,
  });
}

class ImageObject {
  final String name;
  final String imageUrl;

  ImageObject({
    required this.name,
    required this.imageUrl,
  });
}
