import 'package:field_zoom_pro_web/core/models/filter_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final filterNotifierProvider =
    StateNotifierProvider<FilterNotifier, FilterModel>((ref) {
  return FilterNotifier();
});

class FilterNotifier extends StateNotifier<FilterModel> {
  FilterNotifier()
      : super(
          FilterModel(
              startDate: DateHelpers.startOfTodayDate(),
              endDate: DateHelpers.endOfTodayDate()),
        );

  void updateFilter({
    UserModel? loggedInUser,
    String? selectedUserId,
    String? region,
    String? route,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    state = state.copyWith(
      loggedInuser: loggedInUser,
      selectedUserId: selectedUserId,
      region: region,
      route: route,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // reset filter
  void resetFilter() {
    state = FilterModel(
      loggedInuser: state.loggedInuser,
      startDate: DateHelpers.startOfTodayDate(),
      endDate: DateHelpers.endOfTodayDate(),
    );
  }
}
