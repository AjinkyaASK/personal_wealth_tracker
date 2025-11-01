import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  DashboardService._();

  static DashboardService get instance => _instance;
  static final DashboardService _instance = DashboardService._();

  Future<QuerySnapshot<Map<String, dynamic>>> getAssets(
    final String userId,
  ) async {
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('asset')
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLiabilities(
    final String userId,
  ) async {
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('liability')
        .get();
  }
}
