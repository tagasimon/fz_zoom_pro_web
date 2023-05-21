import 'package:field_zoom_pro_web/features/customers/presentation/widgets/customers_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class CustomersBottomSheetWidget extends ConsumerWidget {
  final List<CustomerModel> customers;
  const CustomersBottomSheetWidget({super.key, required this.customers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            context.pop(false),
      },
      child: Focus(
        autofocus: true,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Stack(children: [
                customersMapWidget(customers: customers),
                // Positioned(
                //   // bottom left
                //   bottom: 0,
                //   left: 0,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Card(
                //         child: Row(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             DataTable(
                //               showBottomBorder: true,
                //               columns: const [
                //                 DataColumn(label: Text('KPI')),
                //                 DataColumn(label: Text('#')),
                //               ],
                //               rows: const [
                //                 DataRow(cells: [
                //                   DataCell(Text('Total Visits')),
                //                   DataCell(Text('0')),
                //                 ]),
                //                 DataRow(cells: [
                //                   DataCell(Text('Distict Customers')),
                //                   DataCell(Text('0')),
                //                 ]),
                //               ],
                //             ),
                //             const VerticalDivider(),
                //             DataTable(
                //               showBottomBorder: true,
                //               columns: const [
                //                 DataColumn(label: Text('AGENT')),
                //                 DataColumn(label: Text('#VISITS')),
                //               ],
                //               rows: const [
                //                 // for (var r in distictAgents)
                //                 //   DataRow(cells: [
                //                 //     DataCell(Text(r)),
                //                 //     DataCell(Text(
                //                 //         '${VisitAdherenceUtils.totalNumberOfVisitsByAgent(data: userVisits, agent: r)}')),
                //                 //   ]),
                //               ],
                //             ),
                //             const VerticalDivider(),
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // ),
              ]),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              flex: 1,
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SfDonutChart(
                        // bgColor: Theme.of(context).primaryColor,
                        // barColor: Theme.of(context).primaryColor,
                        // xlabColor: Colors.white,
                        chartData: CustomerChartUtils.customersPerDistrict(
                            customers: customers),
                        // isInverted: false,
                        title: 'DISTRICTS',
                        // axisTitle: "",
                        // height: 400,
                      ),
                      SfPieChart(
                        // bgColor: Theme.of(context).primaryColor,
                        // barColor: Theme.of(context).primaryColor,
                        // xlabColor: Colors.white,
                        chartData: CustomerChartUtils.customersPerBusinessType(
                            customers: customers),
                        // isInverted: false,
                        title: 'BUSINESS TYPES',
                        // axisTitle: "",
                        // height: 400,
                      ),
                      SfBarChart(
                        bgColor: Colors.white,
                        barColor: Theme.of(context).primaryColor,
                        xlabColor: Theme.of(context).primaryColor,
                        chartData: CustomerChartUtils.customersPerRoute(
                            customers: customers),
                        isInverted: false,
                        title: 'TOP ROUTES',
                        axisTitle: "",
                        height: 400,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}