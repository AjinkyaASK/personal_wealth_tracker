import 'package:personal_wealth_tracker/feature/dashboard/model/asset.dart';
import 'package:personal_wealth_tracker/feature/dashboard/model/liability.dart';

enum DashboardViewStateStatus { initial, loading, loaded, error }

class DashboardViewState {
  final Map<String, List<Asset>> assets;
  final Map<String, List<Liability>> liabilities;
  final DashboardViewStateStatus status;
  final String? errorMessage;

  DashboardViewState({
    this.assets = const {},
    this.liabilities = const {},
    this.status = DashboardViewStateStatus.initial,
    this.errorMessage,
  });
}
