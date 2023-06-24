import 'package:field_zoom_pro_web/features/authentication/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';

class CollectionsBySalesPerson extends ConsumerWidget {
  final List<PayementModel> collections;
  const CollectionsBySalesPerson({super.key, required this.collections});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mFormat = NumberFormat("UGX #,###.0");
    final Map<String, double> topSalesMan =
        PayementsUtils.getCollectionsByPerson(payements: collections);

    final scrollController = ScrollController();
    if (scrollController.hasClients) {
      scrollController.jumpTo(50.0);
    }
    return DataTable(
      showBottomBorder: true,
      columns: const [
        DataColumn(label: Text('SALES REP')),
        DataColumn(label: Text('AMOUNT')),
      ],
      rows: [
        for (final entry in topSalesMan.entries)
          DataRow(cells: [
            DataCell(
              Consumer(builder: (context, ref, _) {
                final salesManProv = ref.watch(findUserByIdProvider(entry.key));
                return salesManProv.when(
                  data: (data) {
                    return Text(data.name);
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => const Center(child: Text("Error")),
                );
              }),
            ),
            DataCell(SelectableText(mFormat.format(entry.value))),
          ]),
      ],
    );
  }
}
