import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_catalogue_app/models/catalogue_model.dart';
import 'package:clean_catalogue_app/providers/user_provider.dart';
import 'package:clean_catalogue_app/components/radial_gauge.dart';
import 'package:clean_catalogue_app/services/backend_service.dart';
import 'package:clean_catalogue_app/models/catalogue_scores_model.dart';

class CatalogueDetailScreen extends ConsumerStatefulWidget {
  final Catalogue curCatalogue;

  const CatalogueDetailScreen({super.key, required this.curCatalogue});

  @override
  ConsumerState<CatalogueDetailScreen> createState() =>
      _CatalogueDetailScreenState();
}

class _CatalogueDetailScreenState extends ConsumerState<CatalogueDetailScreen> {
  var _isScanning = false;

  void _setIsScanning() {
    setState(() {
      _isScanning = !_isScanning;
    });
  }

  void _showSnackBar({required String message}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _scanCatalogue() async {
    CatalogueScores? scores;
    final currUser = ref.watch(userProvider);

    try {
      _setIsScanning();
      scores = await scanCatalogue(
        images: widget.curCatalogue.images,
        catalogueName: widget.curCatalogue.name,
        catalogueDescription: widget.curCatalogue.description,
        currUser: currUser,
      );

      final Catalogue catalogue = Catalogue(
        catalogueID: widget.curCatalogue.catalogueID,
        name: widget.curCatalogue.name,
        images: widget.curCatalogue.images,
        date: widget.curCatalogue.date,
        description: widget.curCatalogue.description,
        result: scores!,
      );

      ref.watch(userProvider.notifier).updateStateCatalogue(catalogue);

      _showSnackBar(message: "Catalogue scanned successfully.");
      _setIsScanning();
    } catch (error) {
      _setIsScanning();
      debugPrint(error.toString());
      _showSnackBar(
        message: "An error occured scanning catalogue, please try again later.",
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Catalogue catalogue = ref
        .watch(userProvider)
        .catalogues!
        .singleWhere((c) => c.catalogueID == widget.curCatalogue.catalogueID);

    double aggregateScore = ((0.20) * catalogue.result.productDescriptions +
        (0.20) * catalogue.result.pricingInformation +
        (0.15) * catalogue.result.productImages +
        (0.10) * catalogue.result.layoutAndDesign +
        (0.10) * catalogue.result.discountsAndPromotions +
        (0.10) * catalogue.result.brandConsistency +
        (0.05) * catalogue.result.contactInformationAndCallToAction +
        (0.05) * catalogue.result.typosAndGrammar +
        (0.05) * catalogue.result.legalCompliance);

    aggregateScore = double.parse((aggregateScore.toStringAsFixed(2)));

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(catalogue.name),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF2F66D0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(17, 20, 17, 7),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Your File/s",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Status",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: catalogue.images.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${index + 1}. Image${index + 1}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text("Uploaded"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF2F66D0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 13, 14, 7),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Text(
                                  'Detailed Analysis',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.bold,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 250,
                                  height: 250,
                                  child: RadialGuage(
                                    aggregateScore: aggregateScore,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Product Descriptions:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const Spacer(),
                                        Text(
                                            "${catalogue.result.productDescriptions} %")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Product Images:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const Spacer(),
                                        Text(
                                            "${catalogue.result.productImages} %")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Layout and Design:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const Spacer(),
                                        Text(
                                            "${catalogue.result.layoutAndDesign} %")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Pricing Information:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const Spacer(),
                                        Text(
                                            "${catalogue.result.pricingInformation} %")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Discounts and Promotions:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const Spacer(),
                                        Text(
                                            "${catalogue.result.discountsAndPromotions} %")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Brand Consistency:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const Spacer(),
                                        Text(
                                            "${catalogue.result.brandConsistency} %")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Contact Information:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Text(
                                            "${catalogue.result.contactInformationAndCallToAction} %")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Typos and Grammar:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const Spacer(),
                                        Text(
                                            "${catalogue.result.typosAndGrammar} %")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Legal Compliance:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const Spacer(),
                                        Text(
                                            "${catalogue.result.legalCompliance} %")
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Area of Improvement:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.bold,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      catalogue.result.areaOfImprovement,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _scanCatalogue,
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    backgroundColor: const Color(0xFF2F66D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    !_isScanning ? "Scan Again" : "Scanning...",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
