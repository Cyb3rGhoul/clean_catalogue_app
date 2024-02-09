import 'package:flutter/material.dart';
import 'package:clean_catalogue_app/models/catalogue_model.dart';
import 'package:clean_catalogue_app/screens/catalogue_detail_screen.dart';

class ScanListItem extends StatelessWidget {
  const ScanListItem({required this.catalogue, super.key});

  final Catalogue catalogue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                CatalogueDetailScreen(curCatalogue: catalogue),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.fromLTRB(7, 15, 0, 5),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                foregroundImage: NetworkImage(
                  catalogue.images[0].imageUrl,
                ),
              ),
              const Spacer(flex: 1),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      catalogue.name,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
