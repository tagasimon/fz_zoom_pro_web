import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class VisitsSummaryTableWidget extends ConsumerWidget {
  final List<VisitModel> visits;
  const VisitsSummaryTableWidget({super.key, required this.visits});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalVisits = VisitAdherenceUtils.totalNumberOfVisits(data: visits);
    final totalDistictCustomers =
        VisitAdherenceUtils.totalDistictCustomersVisits(data: visits);
    return Card(
      child: DataTable(
        showBottomBorder: true,
        columns: const [
          DataColumn(label: Text('KPI')),
          DataColumn(label: Text('VALUE')),
        ],
        rows: [
          DataRow(cells: [
            const DataCell(Text('TOTAL VISITS')),
            DataCell(Text('$totalVisits')),
          ]),
          DataRow(cells: [
            const DataCell(Text('UNUQUE VISITS')),
            DataCell(Text('$totalDistictCustomers')),
          ]),
        ],
      ),
    );
  }
}
