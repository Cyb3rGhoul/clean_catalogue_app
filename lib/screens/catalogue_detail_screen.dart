import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:clean_catalogue_app/signup_image.dart';
import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:clean_catalogue_app/screens/scan_screen.dart';
import 'package:clean_catalogue_app/models/catalogue_model.dart';
import 'package:clean_catalogue_app/screens/landing_screen.dart';
import 'package:clean_catalogue_app/components/main_drawer.dart';

class CatalogueDetailScreen extends StatefulWidget {
  final UserModel currUser;
  final Catalogue catalogue;

  const CatalogueDetailScreen(
      {super.key, required this.catalogue, required this.currUser});

  @override
  State<CatalogueDetailScreen> createState() => _CatalogueDetailScreenState();
}

class _CatalogueDetailScreenState extends State<CatalogueDetailScreen> {
  void _setScreen(String identifier) {
    Navigator.of(context).pop();
    if (identifier == 'scan') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ScanScreen(currUser: widget.currUser),
        ),
      );
    }
  }

  void _navigateToLandingScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    _navigateToLandingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catalogue.name),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      drawer: MainDrawer(
        currUser: widget.currUser,
        onSelectScreen: _setScreen,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
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
                        Row(
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
                        SizedBox(
                          height: 13,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.catalogue.images.length,
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
                                              "${index + 1}. ${widget.catalogue.images[index].name}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
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
                                  SizedBox(
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
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 40),
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
                    padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            child: SvgPicture.string(
                              svgString,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Product Descriptions: ${widget.catalogue.result.productDescriptions}%"),
                              Text(
                                  "Pricing Information: ${widget.catalogue.result.pricingInformation}%"),
                              Text(
                                  "Product Images: ${widget.catalogue.result.productImages}%"),
                              Text(
                                  "Layout and Design: ${widget.catalogue.result.layoutAndDesign}%"),
                              Text(
                                  "Discounts and Promotions: ${widget.catalogue.result.discountsAndPromotions}%"),
                              Text(
                                  "Brand Consistency: ${widget.catalogue.result.brandConsistency}%"),
                              Text(
                                "Contact Information and Call To Action: ${widget.catalogue.result.contactInformationAndCallToAction}%",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Text(
                                  "Typos and Grammar: ${widget.catalogue.result.typosAndGrammar}%"),
                              Text(
                                  "Legal Compliance: ${widget.catalogue.result.legalCompliance}%"),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Area of Improvement:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
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
                                side: BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              shadows: [
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
                                  widget.catalogue.result.areaOfImprovement),
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
        ],
      ),
    );
  }
}
