import 'package:flutter/material.dart';
import 'package:personal_wealth_tracker/feature/common/currency_util.dart';
import 'package:personal_wealth_tracker/feature/dashboard/dashboard_controller.dart';
import 'package:personal_wealth_tracker/feature/dashboard/model/dashboard_view_state.dart';
import 'package:personal_wealth_tracker/feature/dashboard/widget/amount_info_tile.dart';
import 'package:personal_wealth_tracker/feature/dashboard/widget/pie_chart.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final DashboardController controller = DashboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Wealth Tracker')),
      body: ValueListenableBuilder(
        valueListenable: controller.viewState,
        builder: (context, viewState, _) {
          switch (viewState.status) {
            case DashboardViewStateStatus.initial:
              return const Center(
                child: Text('Welcome to Personal Wealth Tracker'),
              );

            case DashboardViewStateStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case DashboardViewStateStatus.error:
              return Center(child: Text('Error: ${viewState.errorMessage}'));

            case DashboardViewStateStatus.loaded:
              final double totalAssets = viewState.assets.values
                  .expand((list) => list)
                  .fold(0.0, (sum, asset) => sum + asset.value);
              final double totalLiabilities = viewState.liabilities.values
                  .expand((list) => list)
                  .fold(0.0, (sum, liability) => sum + liability.value);
              final double debtRatio = totalAssets == 0
                  ? 0
                  : (totalLiabilities / totalAssets) / 100;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Asset, Liability, Debt-ratio figures
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: AmountInfoTile(
                                title: 'Assets',
                                amount: totalAssets,
                                color: Colors.green,
                              ),
                            ),
                            Expanded(
                              child: AmountInfoTile(
                                title: 'Liabilities',
                                amount: totalLiabilities,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Debt Ratio: ${debtRatio.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    // Graphs
                    Column(
                      children: [
                        // Assets and Liabilities Pie Chart
                        ExpansionTile(
                          title: SizedBox(
                            height: 200,
                            child: FinancePieChart(
                              data: [
                                FinancePieChartDataItem(
                                  title: 'Assets',
                                  value: totalAssets,
                                  color: Colors.green.shade600,
                                ),
                                FinancePieChartDataItem(
                                  title: 'Liabilities',
                                  value: totalLiabilities,
                                  color: Colors.red.shade600,
                                ),
                              ],
                            ),
                          ),
                          children: [
                            Divider(height: 1),
                            // Assets
                            SizedBox(
                              height: 200,
                              child: FinancePieChart(
                                data: viewState.assets.entries.map((entry) {
                                  final double categoryTotal = entry.value.fold(
                                    0.0,
                                    (sum, asset) => sum + asset.value,
                                  );
                                  return FinancePieChartDataItem(
                                    title: entry.key,
                                    value: categoryTotal,
                                    color:
                                        Colors.primaries[entry.key.hashCode %
                                            Colors.primaries.length],
                                  );
                                }).toList(),
                              ),
                            ),
                            Divider(height: 1),
                            // Liabilities
                            SizedBox(
                              height: 200,
                              child: FinancePieChart(
                                data: viewState.liabilities.entries.map((
                                  entry,
                                ) {
                                  final double categoryTotal = entry.value.fold(
                                    0.0,
                                    (sum, liability) => sum + liability.value,
                                  );
                                  return FinancePieChartDataItem(
                                    title: entry.key,
                                    value: categoryTotal,
                                    color:
                                        Colors.primaries[entry.key.hashCode %
                                            Colors.primaries.length],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Assets (category-wise)
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(text: 'Assets', icon: Icon(Icons.wallet)),
                              Tab(text: 'Liabilities', icon: Icon(Icons.money)),
                            ],
                          ),
                          SizedBox(
                            height: 400,
                            child: TabBarView(
                              children: [
                                // Assets
                                ListView.builder(
                                  itemCount: viewState.assets.keys.length,
                                  itemBuilder: (context, index) {
                                    return ExpansionTile(
                                      title: Text(
                                        viewState.assets.keys.elementAt(index),
                                      ),
                                      children: viewState.assets.values
                                          .elementAt(index)
                                          .map(
                                            (asset) => ListTile(
                                              title: Text(asset.label),
                                              trailing: Text(
                                                getFormattedCurrency(
                                                  asset.value,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    );
                                  },
                                ),
                                // Liabilities
                                ListView.builder(
                                  itemCount: viewState.liabilities.keys.length,
                                  itemBuilder: (context, index) {
                                    return ExpansionTile(
                                      title: Text(
                                        viewState.liabilities.keys.elementAt(
                                          index,
                                        ),
                                      ),
                                      children: viewState.liabilities.values
                                          .elementAt(index)
                                          .map(
                                            (liability) => ListTile(
                                              title: Text(liability.label),
                                              trailing: Text(
                                                getFormattedCurrency(
                                                  liability.value,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
