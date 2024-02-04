class CatalogueScores {
  final int productDescriptions;
  final int pricingInformation;
  final int productImages;
  final int layoutAndDesign;
  final int discountsAndPromotions;
  final int brandConsistency;
  final int contactInformationAndCallToAction;
  final int typosAndGrammar;
  final int legalCompliance;
  final String areaOfImprovement;

  CatalogueScores({
    required this.areaOfImprovement,
    required this.productDescriptions,
    required this.pricingInformation,
    required this.productImages,
    required this.layoutAndDesign,
    required this.discountsAndPromotions,
    required this.brandConsistency,
    required this.contactInformationAndCallToAction,
    required this.typosAndGrammar,
    required this.legalCompliance,
  });

  Map<String, dynamic> toMap() {
    return {
      'productDescriptions': productDescriptions,
      'pricingInformation': pricingInformation,
      'productImages': productImages,
      'layoutAndDesign': layoutAndDesign,
      'discountsAndPromotions': discountsAndPromotions,
      'brandConsistency': brandConsistency,
      'contactInformationAndCallToAction': contactInformationAndCallToAction,
      'typosAndGrammar': typosAndGrammar,
      'legalCompliance': legalCompliance,
      'areaOfImprovement': areaOfImprovement,
    };
  }

  factory CatalogueScores.fromMap(Map<String, dynamic> map) {
    return CatalogueScores(
      areaOfImprovement: map['areaOfImprovement'] as String,
      productDescriptions: map['productDescriptions'] as int,
      pricingInformation: map['pricingInformation'] as int,
      productImages: map['productImages'] as int,
      layoutAndDesign: map['layoutAndDesign'] as int,
      discountsAndPromotions: map['discountsAndPromotions'] as int,
      brandConsistency: map['brandConsistency'] as int,
      contactInformationAndCallToAction:
          map['contactInformationAndCallToAction'] as int,
      typosAndGrammar: map['typosAndGrammar'] as int,
      legalCompliance: map['legalCompliance'] as int,
    );
  }
}
