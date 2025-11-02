import 'package:flutter/material.dart';
import 'package:personal_wealth_tracker/feature/common/currency_util.dart';
import 'package:personal_wealth_tracker/feature/dashboard/dashboard_controller.dart';
import 'package:personal_wealth_tracker/feature/dashboard/model/dashboard_view_state.dart';
import 'package:personal_wealth_tracker/feature/dashboard/widget/amount_info_tile.dart';
import 'package:personal_wealth_tracker/feature/dashboard/widget/amount_info_tile_horizontal.dart';
import 'package:personal_wealth_tracker/feature/dashboard/widget/finance_pie_chart.dart';
import 'package:personal_wealth_tracker/feature/dashboard/widget/section_title.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final DashboardController controller = DashboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wealth Overview'),
        actionsPadding: const EdgeInsets.only(right: 16),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'logout') {
                await controller.logout();
              }
            },
            offset: const Offset(0, 50),
            itemBuilder: (context) {
              return [PopupMenuItem(value: 'logout', child: Text('Logout'))];
            },
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage: controller.user.photoURL != null
                  ? NetworkImage(controller.user.photoURL!)
                  : null,
              child: controller.user.photoURL == null
                  ? Text(
                      controller.user.displayName != null &&
                              controller.user.displayName!.isNotEmpty
                          ? controller.user.displayName!.substring(0, 1)
                          : 'U',
                      style: const TextStyle(color: Colors.white),
                    )
                  : null,
            ),
          ),
        ],
      ),
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
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 256),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Asset, Liability, Debt-ratio figures
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: IntrinsicHeight(
                        child: Row(
                          spacing: 16,
                          children: [
                            Expanded(
                              child: AmountInfoTile(
                                title: 'Assets',
                                icon: Icon(
                                  Icons.trending_up,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                amount: controller.totalAssets,
                                color: Colors.green,
                              ),
                            ),
                            Expanded(
                              child: AmountInfoTile(
                                title: 'Liabilities',
                                icon: Icon(
                                  Icons.trending_down,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                amount: controller.totalLiabilities,
                                color: Colors.red,
                              ),
                            ),
                            // Expanded(
                            //   child: AmountInfoTile(
                            //     title: 'Ratio',
                            //     icon: Icon(
                            //       Icons.balance,
                            //       color: Colors.white,
                            //       size: 24,
                            //     ),
                            //     amount: controller.debtRatio,
                            //     color: Colors.amber,
                            //     formatNumber: false,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AmountInfoTileHorizontal(
                        title: 'Debt Ratio',
                        icon: Icon(
                          Icons.balance,
                          color: Colors.amber,
                          size: 24,
                        ),
                        amount: controller.debtRatio,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        formatNumber: false,
                      ),
                    ),
                    // Graphs
                    SectionTitle('Assets vs Liabilities'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ExpansionTile(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        collapsedBackgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        tilePadding: const EdgeInsets.only(right: 16),
                        title: SizedBox(
                          height: 240,
                          child: FinancePieChart(
                            data: [
                              FinancePieChartDataItem(
                                title: 'Assets',
                                value: controller.totalAssets,
                                color: Colors.green.shade500,
                              ),
                              FinancePieChartDataItem(
                                title: 'Liabilities',
                                value: controller.totalLiabilities,
                                color: Colors.red.shade300,
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Divider(height: 1),
                          // Assets
                          SizedBox(
                            height: 240,
                            child: FinancePieChart(
                              title: 'Assets',
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
                            height: 240,
                            child: FinancePieChart(
                              title: 'Liabilities',
                              data: viewState.liabilities.entries.map((entry) {
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
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SectionTitle('Category-wise Details'),
                    ),
                    // Assets (category-wise)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            const TabBar(
                              tabs: [
                                Tab(text: 'Assets'),
                                Tab(text: 'Liabilities'),
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
                                          viewState.assets.keys.elementAt(
                                            index,
                                          ),
                                        ),
                                        children: viewState.assets.values
                                            .elementAt(index)
                                            .map(
                                              (asset) => ListTile(
                                                title: Text(asset.label),
                                                trailing: Text(
                                                  getFormattedCurrencyFull(
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
                                    itemCount:
                                        viewState.liabilities.keys.length,
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
                                                  getFormattedCurrencyFull(
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
