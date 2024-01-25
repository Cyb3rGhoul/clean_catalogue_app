class Catalogue {
  final String catalogueID;
  final String name;
  final List<String> imageUrls;
  String? description;

  Catalogue({
    required this.name,
    required this.catalogueID,
    required this.imageUrls,
    this.description,
  });
}
