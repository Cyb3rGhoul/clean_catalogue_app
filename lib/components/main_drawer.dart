import 'package:flutter/material.dart';
import 'package:clean_catalogue_app/models/user_model.dart';

class MainDrawer extends StatelessWidget {
  final UserModel currUser;

  const MainDrawer(
      {super.key, required this.onSelectScreen, required this.currUser});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF2F66D0),
            ),
            padding: const EdgeInsets.fromLTRB(26, 15, 0, 15),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Welcome,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        currUser.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.document_scanner_outlined,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: const Text(
              'Scan Catalogue',
            ),
            onTap: () {
              onSelectScreen('scan');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: const Text(
              'Catalogue History',
            ),
            onTap: () {
              onSelectScreen('history');
            },
          ),
        ],
      ),
    );
  }
}
