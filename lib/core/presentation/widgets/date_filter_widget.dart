import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
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
    final filter = ref.watch(sessionNotifierProvider);
    return TextButton.icon(
      style: TextButton.styleFrom(foregroundColor: Colors.white),
      onPressed: () async {
        final DateTime? pDate = await showDialog(
          context: context,
          builder: (_) => DatePickerDialog(
            helpText: title ?? "",
            initialDate: ref.read(sessionNotifierProvider).startDate,
            firstDate: DateTime(2023),
            lastDate: DateTime(2030),
          ),
        );
        if (pDate == null) return;
        // TODO Look at these Date Selected Whether its Start of Day or End of Day
        if (isStartDate) {
          ref
              .read(sessionNotifierProvider.notifier)
              .updateSession(startDate: pDate);
        } else {
          ref
              .read(sessionNotifierProvider.notifier)
              .updateSession(endDate: pDate);
        }
      },
      icon: const Icon(Icons.calendar_month),
      label: isStartDate
          ? Text("FROM : ${dateFormat.format(filter.startDate)}")
          : Text("TO : ${dateFormat.format(filter.endDate)}"),
    );
  }
}
