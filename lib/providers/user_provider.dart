import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:clean_catalogue_app/models/catalogue_model.dart';

class UserModelNotifier extends StateNotifier<UserModel> {
  UserModelNotifier()
      : super(
          UserModel(
            userID: '',
            username: '',
            email: '',
            catalogues: null,
          ),
        );

  void createUserState(
    List<Catalogue>? catalogues, {
    required String userID,
    required String username,
    required String email,
  }) {
    state = UserModel(
      userID: userID,
      username: username,
      email: email,
      catalogues: catalogues,
    );
  }

  void addStateCatalogue(Catalogue catalogue) {
    if (state.catalogues == null) {
      state.catalogues = [catalogue];
    } else {
      state.catalogues?.add(catalogue);
    }
  }

  void updateStateCatalogue(Catalogue catalogue) {
    if (state.catalogues == null) return;

    final catalogueIndex = state.catalogues!
        .indexWhere((c) => c.catalogueID == catalogue.catalogueID);

    if (catalogueIndex != -1) {
      state.catalogues![catalogueIndex] = catalogue;
    } else {
      state.catalogues!.add(catalogue);
    }
  }
}

final userProvider = StateNotifierProvider<UserModelNotifier, UserModel>(
  (ref) => UserModelNotifier(),
);
