import 'package:flutter/material.dart';

class EditImageListItem extends StatelessWidget {
  const EditImageListItem(
      {required this.imageName,
      required this.imageIndex,
      required this.onDeleteImage,
      super.key});

  final String imageName;
  final int imageIndex;
  final void Function() onDeleteImage;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 17),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "$imageIndex. $imageName",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: onDeleteImage,
              style: IconButton.styleFrom(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(
                Icons.delete,
                color: Color(0xFF2F66D0),
              ),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
