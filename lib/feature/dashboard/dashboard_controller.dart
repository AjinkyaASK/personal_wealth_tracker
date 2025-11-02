import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_wealth_tracker/feature/dashboard/dashboard_service.dart';
import 'package:personal_wealth_tracker/feature/dashboard/model/asset.dart';
import 'package:personal_wealth_tracker/feature/dashboard/model/dashboard_view_state.dart';
import 'package:personal_wealth_tracker/feature/dashboard/model/liability.dart';
import 'package:personal_wealth_tracker/feature/login/auth_controller.dart';

class DashboardController extends ChangeNotifier {
  DashboardController() {
    init();
  }

  final DashboardService _service = DashboardService.instance;

  final String userId = 'dUGg62AqIC9fwTDVit9d';

  ValueNotifier<DashboardViewState> viewState = ValueNotifier(
    DashboardViewState(),
  );
  final Map<String, List<Asset>> assets = {};
  final Map<String, List<Liability>> liabilities = {};

  // TODO: Optimize calculations by caching values and updating only when data changes
  double get totalAssets => viewState.value.assets.values
      .expand((list) => list)
      .fold(0.0, (sum, asset) => sum + asset.value);
  double get totalLiabilities => viewState.value.liabilities.values
      .expand((list) => list)
      .fold(0.0, (sum, liability) => sum + liability.value);
  double get debtRatio =>
      totalAssets == 0 ? 0 : (totalLiabilities / totalAssets) / 100;
  double get netWorth => totalAssets - totalLiabilities;

  Future<void> init() async {
    await loadAssetsAndLiabilities();
  }

  Future<void> loadAssetsAndLiabilities() async {
    // Start loading
    viewState.value = DashboardViewState(
      status: DashboardViewStateStatus.loading,
      assets: viewState.value.assets,
      liabilities: viewState.value.liabilities,
    );

    // Fetch data
    await fetchAssets();
    await fetchLiabilities();

    // Set data loaded
    viewState.value = DashboardViewState(
      status: DashboardViewStateStatus.loaded,
      assets: assets,
      liabilities: liabilities,
    );
  }

  Future<void> fetchAssets() async {
    final Map<String, List<Asset>> assets = {};

    // Fetch assets from service
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _service
        .getAssets(userId);

    // Process assets
    for (final e in snapshot.docs) {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('asset')
          .doc(e.id);
      final DocumentSnapshot docSnapshot = await docRef.get();
      final Map<String, dynamic> docData =
          docSnapshot.data() as Map<String, dynamic>? ?? {};

      assets[e.id] = [];

      for (final f in docData.entries) {
        assets[e.id]!.add(
          Asset.fromMap({'category': e.id, 'label': f.key, 'value': f.value}),
        );
      }
    }

    this.assets.clear();
    this.assets.addAll(assets);

    // TODO: Handle error cases
  }

  Future<void> fetchLiabilities() async {
    final Map<String, List<Liability>> liabilities = {};

    // Fetch liabilities from service
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _service
        .getLiabilities(userId);

    // Process assets
    for (final e in snapshot.docs) {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('liability')
          .doc(e.id);
      final DocumentSnapshot docSnapshot = await docRef.get();
      final Map<String, dynamic> docData =
          docSnapshot.data() as Map<String, dynamic>? ?? {};

      liabilities[e.id] = [];

      for (final f in docData.entries) {
        liabilities[e.id]!.add(
          Liability.fromMap({
            'category': e.id,
            'label': f.key,
            'value': f.value,
          }),
        );
      }
    }

    this.liabilities.clear();
    this.liabilities.addAll(liabilities);

    // TODO: Handle error cases
  }

  User get user {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    return user;
  }

  Future<void> logout() async {
    await AuthController.instance.logout();
  }
}
