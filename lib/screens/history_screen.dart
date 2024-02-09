import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_catalogue_app/screens/scan_screen.dart';
import 'package:clean_catalogue_app/models/catalogue_model.dart';
import 'package:clean_catalogue_app/components/main_drawer.dart';
import 'package:clean_catalogue_app/screens/landing_screen.dart';
import 'package:clean_catalogue_app/providers/user_provider.dart';
import 'package:clean_catalogue_app/services/backend_service.dart';
import 'package:clean_catalogue_app/components/scan_list_item.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  List<Catalogue>? _catalogueList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCatalogues();
  }

  void _getCatalogues() async {
    final currUser = ref.watch(userProvider);

    _catalogueList = await getCatalogues(userID: currUser.userID);

    if (_catalogueList != null) {
      ref.read(userProvider.notifier).changeUserState(
            _catalogueList!,
            userID: currUser.userID,
            username: currUser.username,
            email: currUser.email,
          );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _setScreen(String identifier) {
    if (identifier == 'scan') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const ScanScreen(),
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
    final currUser = ref.watch(userProvider);

    _catalogueList = currUser.catalogues;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Catalogue History',
          ),
          actions: [
            IconButton(
              onPressed: _logout,
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          ],
        ),
        drawer: MainDrawer(
          currUser: currUser,
          onSelectScreen: _setScreen,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF2F66D0),
          ),
        ),
      );
    }

    if (_catalogueList == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Catalogue History',
          ),
          actions: [
            IconButton(
              onPressed: _logout,
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          ],
        ),
        drawer: MainDrawer(
          currUser: currUser,
          onSelectScreen: _setScreen,
        ),
        body: const Center(
          child: Text("Error fetching catalogue, please try again later."),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Catalogue History',
            ),
            actions: [
              IconButton(
                onPressed: _logout,
                icon: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          drawer: MainDrawer(
            currUser: currUser,
            onSelectScreen: _setScreen,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2F66D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: SizedBox(
                          width: 182,
                          height: 35,
                          child: Container(
                            decoration: const ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                            ),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'User Dashboard',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'Judson',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.fromLTRB(12, 48, 12, 12),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name:",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Email Id:",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currUser.username,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      currUser.email,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2F66D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: SizedBox(
                          width: 88,
                          height: 37,
                          child: Container(
                            decoration: const ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                            ),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'History',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'Judson',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.fromLTRB(12, 49, 12, 12),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                          child: currUser.catalogues != null &&
                                  currUser.catalogues!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: currUser.catalogues!.length,
                                  itemBuilder: (context, index) {
                                    return ScanListItem(
                                      catalogue: currUser.catalogues![
                                          currUser.catalogues!.length -
                                              index -
                                              1],
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                    "No catalogues yet, start scanning.",
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
