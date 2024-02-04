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

  Map<String, dynamic> toMap() {
    return {
      'catalogueID': catalogueID,
      'name': name,
      'date': date.toIso8601String(),
      'images': images.map((image) => image.toMap()).toList(),
      'result': result.toMap(),
      'description': description,
    };
  }

  factory Catalogue.fromMap(Map<String, dynamic> map) {
    return Catalogue(
      catalogueID: map['catalogueID'] as String,
      name: map['name'] as String,
      date: DateTime.parse(map['date'] as String),
      images: (map['images'] is List)
          ? (map['images'] as List)
              .map((imageMap) => ImageObject.fromMap(imageMap))
              .toList()
          : [],
      result: CatalogueScores.fromMap(map['result'] as Map<String, dynamic>),
      description: map['description'] as String?,
    );
  }
}

class ImageObject {
  final String name;
  final String imageUrl;

  ImageObject({
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory ImageObject.fromMap(Map<String, dynamic> map) {
    return ImageObject(
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }
}
