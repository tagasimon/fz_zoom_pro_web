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
              startDate: DateHelpers.startDateOfMonth(),
              endDate: DateHelpers.endOfTodayDate()),
        );

  void updateRegion({required String region}) {
    state = FilterModel(
      loggedInuser: state.loggedInuser,
      region: region,
      route: null,
      selectedUserId: null,
      startDate: state.startDate,
      endDate: state.endDate,
    );
  }

  void updateRoute({required String route}) {
    state = FilterModel(
      loggedInuser: state.loggedInuser,
      region: state.region,
      route: route,
      selectedUserId: null,
      startDate: state.startDate,
      endDate: state.endDate,
    );
  }

  void updateSelectedUser({required String selectedUserId}) {
    state = FilterModel(
      loggedInuser: state.loggedInuser,
      region: state.region,
      route: state.route,
      selectedUserId: selectedUserId,
      startDate: state.startDate,
      endDate: state.endDate,
    );
  }

  void updateFilter({
    UserModel? loggedInUser,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    state = state.copyWith(
      loggedInuser: loggedInUser,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // reset filter
  void resetFilter() {
    state = FilterModel(
      loggedInuser: state.loggedInuser,
      startDate: DateHelpers.startDateOfMonth(),
      endDate: DateHelpers.endOfTodayDate(),
    );
  }
}
