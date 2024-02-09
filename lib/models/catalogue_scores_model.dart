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
}
