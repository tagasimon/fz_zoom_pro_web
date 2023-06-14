import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DateFilterWidget extends ConsumerWidget {
  final String? title;
  final bool isStartDate;
  const DateFilterWidget({super.key, this.title, required this.isStartDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat("dd-MMMM-yyyy");
    final filter = ref.watch(filterNotifierProvider);
    return Row(
      children: [
        if (isStartDate) Text("FROM : ${dateFormat.format(filter.startDate!)}"),
        if (!isStartDate) Text("TO : ${dateFormat.format(filter.endDate!)}"),
        IconButton(
          onPressed: () async {
            final DateTime? pDate = await showDialog(
              context: context,
              builder: (_) => DatePickerDialog(
                helpText: title ?? "",
                initialDate: ref.read(filterNotifierProvider).startDate!,
                firstDate: DateTime(2023),
                lastDate: DateTime(2030),
              ),
            );
            if (pDate == null) return;
            if (isStartDate) {
              ref
                  .read(filterNotifierProvider.notifier)
                  .updateFilter(startDate: pDate);
            } else {
              ref
                  .read(filterNotifierProvider.notifier)
                  .updateFilter(endDate: pDate);
            }
          },
          icon: const Icon(Icons.calendar_month),
        ),
      ],
    );
  }
}
