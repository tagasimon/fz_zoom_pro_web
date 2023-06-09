import 'package:field_zoom_pro_web/core/models/filter_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class FilterNotifier extends StateNotifier<FilterModel> {
  FilterNotifier()
      : super(FilterModel(
            startDate: DateHelpers.startOfTodayDate(),
            endDate: DateHelpers.endOfTodayDate()));

  void updateFilter({
    UserModel? user,
    String? region,
    String? route,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    state = state.copyWith(
      user: user,
      region: region,
      route: route,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // reset filter
  void resetFilter() {
    state = FilterModel(
      user: state.user,
      startDate: DateHelpers.startOfTodayDate(),
      endDate: DateHelpers.endOfTodayDate(),
    );
  }
}
