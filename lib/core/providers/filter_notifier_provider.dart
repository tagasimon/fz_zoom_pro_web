import 'package:field_zoom_pro_web/core/models/filter_model.dart';
import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterNotifierProvider =
    StateNotifierProvider<FilterNotifier, FilterModel>((ref) {
  return FilterNotifier();
});
